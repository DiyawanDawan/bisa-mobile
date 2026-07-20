import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart' hide State;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/core/errors/failures.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/features/orders/domain/repositories/order_repository.dart';
import 'package:mobile_bisa/features/orders/presentation/bloc/order_cubit.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/payment_method_resolver.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/payment_result_utils.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/order_dispute_section.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_expiry_banner.dart';
import 'package:mobile_bisa/features/bisa_express/data/datasources/bisa_express_remote_data_source.dart';
import 'package:mobile_bisa/features/bisa_express/presentation/widgets/bisa_express_timeline_sheet.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/order_tracking_map.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_method_picker_sheet.dart';
import 'package:mobile_bisa/features/marketplace/presentation/pages/write_review_page.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/shared/widgets/bisa_avatar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_dialog.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/order_dispute_i18n.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/order_shipment_utils.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/order_status_i18n.dart';
import 'package:mobile_bisa/features/partnership/presentation/utils/partnership_pdf_export_helper.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  /// Set `true` setelah checkout dari keranjang — lanjut bayar tanpa minta metode lagi
  /// jika [initialPaymentCode] / metode tersimpan sudah ada.
  final bool autoStartPayment;
  /// Metode yang sudah dipilih di checkout — jangan tampilkan picker lagi.
  final String? initialPaymentCode;
  final String? initialPaymentName;

  const OrderDetailPage({
    super.key,
    required this.orderId,
    this.autoStartPayment = false,
    this.initialPaymentCode,
    this.initialPaymentName,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderEntity? _order;
  Map<String, dynamic>? _pendingPayment;
  String? _selectedChannelCode;
  String? _selectedChannelName;
  bool _autoPickTriggered = false;
  bool _paymentBusy = false;
  bool _trackingSyncBusy = false;
  bool _requestPickupBusy = false;
  bool _showFullReview = false;
  final _imagePicker = ImagePicker();
  /// Cubit lokal dari BlocProvider halaman ini — jangan pakai `context.read`
  /// dari State (itu mengarah ke cubit global di main.dart).
  OrderCubit? _pageOrderCubit;
  List<String> _batchOrderIds = const [];
  bool _batchContextLoaded = false;

  @override
  void initState() {
    super.initState();
    final code = widget.initialPaymentCode?.trim();
    if (code != null && code.isNotEmpty) {
      _selectedChannelCode = code;
      _selectedChannelName =
          widget.initialPaymentName?.trim().isNotEmpty == true
              ? widget.initialPaymentName!.trim()
              : code;
    }
  }

  void _applyOrder(OrderEntity order) {
    setState(() {
      _order = order;
      _paymentBusy = false;
      if (order.status == 'PENDING') {
        _pendingPayment = order.pendingPayment ?? _pendingPayment;
        _syncSelectedChannelFromOrder(order);
      } else {
        _pendingPayment = order.pendingPayment;
        _selectedChannelCode = order.transaction?.paymentChannelCode ??
            order.pendingPayment?['channelCode']?.toString();
        _selectedChannelName = order.transaction?.paymentChannelName ??
            order.pendingPayment?['channelName']?.toString() ??
            _selectedChannelCode;
      }
    });
    unawaited(_maybeHydrateSavedPayment(order));
    _maybeAutoPickPaymentMethod(order);
    _loadBatchPaymentContext(order);
  }

  /// Prefill metode dari profil jika belum ada — supaya tidak kosong di UI.
  Future<void> _maybeHydrateSavedPayment(OrderEntity order) async {
    if (order.status != 'PENDING') return;
    if (_selectedChannelCode != null && _selectedChannelCode!.isNotEmpty) {
      return;
    }
    final saved = await _loadSavedPaymentPreference();
    if (!mounted || saved == null) return;
    if (_selectedChannelCode != null && _selectedChannelCode!.isNotEmpty) {
      return;
    }
    setState(() {
      _selectedChannelCode = saved.code;
      _selectedChannelName = saved.name;
    });
  }

  Future<void> _loadBatchPaymentContext(OrderEntity order) async {
    final batchId = order.checkoutBatchId?.trim();
    if (batchId == null || batchId.isEmpty || _batchContextLoaded) return;
    _batchContextLoaded = true;

    final result = await sl<OrderRepository>().getCheckoutBatchDetail(order.id);
    if (!mounted) return;
    result.fold((_) {}, (batch) {
      if (batch.orders.length > 1) {
        setState(() {
          _batchOrderIds = batch.orders.map((o) => o.id).toList();
        });
      }
    });
  }

  Future<void> _reloadOrderDetail({bool silent = true}) async {
    final cubit = _pageOrderCubit;
    if (cubit == null || !mounted) return;
    final order = await cubit.getOrderDetail(widget.orderId, silent: silent);
    if (order != null && mounted) {
      _applyOrder(order);
    }
  }

  void _syncSelectedChannelFromOrder(OrderEntity order) {
    if (_selectedChannelCode != null) return;
    final pending = order.pendingPayment;
    _selectedChannelCode = pending?['channelCode']?.toString() ??
        order.transaction?.paymentChannelCode;
    _selectedChannelName = pending?['channelName']?.toString() ??
        order.transaction?.paymentChannelName ??
        _selectedChannelCode;
  }

  String? _resolvedChannelCode(OrderEntity o) {
    return _selectedChannelCode ??
        _pendingPayment?['channelCode']?.toString() ??
        o.transaction?.paymentChannelCode;
  }

  String? _resolvedChannelName(OrderEntity o) {
    return _selectedChannelName ??
        _pendingPayment?['channelName']?.toString() ??
        o.transaction?.paymentChannelName ??
        _resolvedChannelCode(o);
  }

  bool _hasPaymentMethodSelected(OrderEntity o) {
    final code = _resolvedChannelCode(o);
    return code != null && code.isNotEmpty;
  }

  void _maybeAutoPickPaymentMethod(OrderEntity order) {
    if (!widget.autoStartPayment || _autoPickTriggered) return;
    if (order.status != 'PENDING') return;
    _autoPickTriggered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _order == null) return;

      // Sudah punya metode (dari checkout / initial) → langsung bayar, jangan picker lagi.
      if (_hasPaymentMethodSelected(_order!)) {
        await _continueToPayment(context, _order!);
        return;
      }

      // Fallback: metode tersimpan di profil.
      final saved = await _loadSavedPaymentPreference();
      if (!mounted || _order == null) return;
      if (saved != null) {
        setState(() {
          _selectedChannelCode = saved.code;
          _selectedChannelName = saved.name;
        });
        await _continueToPayment(context, _order!);
        return;
      }

      // Baru minta pilih jika belum ada sama sekali.
      await _pickPaymentMethod(context, _order!);
    });
  }

  Future<PaymentMethodChoice?> _loadSavedPaymentPreference() =>
      PaymentMethodResolver.loadSaved();

  Future<void> _openPaymentInstructions(Map<String, dynamic> data) async {
    // POST /pay sudah selesai — jangan tampilkan overlay VA saat buka / kembali.
    if (mounted) setState(() => _paymentBusy = false);

    final paymentConfirmed = await context.push<bool>(
      '/payment-instruction',
      extra: {
        'orderId': widget.orderId,
        'orderNumber': _order?.displayOrderNumber ?? _order?.orderNumber ?? '',
        'amount': data['amount'] ?? _order?.totalAmount ?? 0,
        'paymentResult': data,
        if (_batchOrderIds.length > 1) 'batchOrderIds': _batchOrderIds,
        if (_order?.createdAt != null) 'orderCreatedAt': _order!.createdAt,
        'paymentStatus': _order?.transaction?.paymentStatus,
      },
    );
    if (!mounted) return;
    if (paymentConfirmed == true) {
      await _pollPaymentStatus();
    } else {
      await _reloadOrderDetail();
    }
  }

  /// Navigasi setelah POST /pay sukses — dipanggil langsung dari [_continueToPayment].
  Future<void> _navigateAfterPaymentInit(Map<String, dynamic> data) async {
    final paymentMap = Map<String, dynamic>.from(data);
    if (!mounted) return;
    setState(() => _pendingPayment = paymentMap);

    final mode = (paymentMap['mode'] as String?)?.toUpperCase() ?? '';

    if (mode == 'DIRECT' || paymentInstructionsReady(paymentMap)) {
      await _openPaymentInstructions(paymentMap);
      return;
    }

    final url = paymentMap['invoiceUrl'] ??
        (paymentMap['paymentData'] is Map
            ? paymentMap['paymentData']['redirectUrl']
            : null);
    if (url != null) {
      final webResult = await context.push(
        '/payment-webview',
        extra: {'url': url, 'title': 'orders.payment_webview_title'.tr()},
      );
      if (!mounted) return;
      final exit = parsePaymentWebViewExit(webResult);
      if (exit != PaymentWebViewExit.failed) {
        await _pollPaymentStatus();
      }
      return;
    }

    if (mounted) {
      showBisaSnackBar(
        context,
        content: Text('orders.payment_init_incomplete'.tr()),
        backgroundColor: AppColors.warning,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderCubit>()..getOrderDetail(widget.orderId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'orders.detail_title'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) async {
            await state.maybeWhen(
              loaded: (orders) async {
                if (orders.isNotEmpty) _applyOrder(orders.first);
              },
              error: (message) async {
                // SEC-FIX: payment errors sebelumnya silent. Tampilkan snackbar
                // supaya user tahu kenapa "tidak lanjut" — biasanya karena
                // backend Xendit return 4xx (channel non-aktif, amount minimum,
                // dst), atau jaringan putus.
                if (!context.mounted) return;
                showBisaSnackBar(
                  context,
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.textOnPrimary),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 5),
                );
                // Refresh ke detail terakhir agar UI tidak stuck di error state.
                if (_order != null) {
                  await Future<void>.delayed(const Duration(milliseconds: 100));
                  if (context.mounted) {
                    context
                        .read<OrderCubit>()
                        .getOrderDetail(widget.orderId);
                  }
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            _pageOrderCubit ??= context.read<OrderCubit>();

            // Untuk state `loading` & `paymentSuccess` — kalau `_order` sudah
            // pernah ter-load, tampilkan detail + overlay spinner. Mencegah
            // halaman tiba-tiba kosong saat user klik "Bayar Sekarang".
            if (_order != null) {
              final isProcessing = _paymentBusy;
              return Stack(
                children: [
                  _buildContent(),
                  if (isProcessing)
                    Positioned.fill(
                      child: ColoredBox(
                        color: AppColors.black.withValues(alpha: 0.15),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: AppSpacing.md12),
                                Text(
                                  'orders.payment_creating_va'.tr(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return state.maybeWhen(
              loading: () => Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: const ShimmerListPlaceholder(
                  itemCount: 5,
                  itemHeight: 72,
                ),
              ),
              error: (message) => Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () => context
                            .read<OrderCubit>()
                            .getOrderDetail(widget.orderId),
                        child: Text('orders.reload'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
              loaded: (_) => const SizedBox(),
              orElse: () => Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: const ShimmerListPlaceholder(
                  itemCount: 4,
                  itemHeight: 72,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    final o = _order!;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final currentUser = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    final isSupplier = currentUser?.role == 'SUPPLIER';
    final isBuyer = currentUser?.role == 'BUYER';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(o),
          if (_batchOrderIds.length > 1) ...[
            SizedBox(height: AppSpacing.md12),
            _buildBatchCheckoutBanner(o),
          ],
          if (o.status.toUpperCase() == 'DISPUTED' && o.dispute != null) ...[
            SizedBox(height: AppSpacing.md12),
            OrderDisputeSection(
              order: o,
              isBuyer: isBuyer,
              isSupplier: isSupplier,
              onSupplierRespond: isSupplier && o.dispute!.supplierCanRespond
                  ? () => _showSupplierDisputeResponseDialog(context)
                  : null,
            ),
            if (o.negotiationId != null && o.negotiationId!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.md12),
              CustomButton(
                text: 'orders.open_mediation_chat'.tr(),
                useGradient: true,
                onPressed: () => context.push('/negotiation/${o.negotiationId}'),
              ),
            ] else ...[
              SizedBox(height: AppSpacing.md12),
              CustomButton(
                text: 'orders.load_mediation_chat'.tr(),
                useGradient: true,
                onPressed: () => _pageOrderCubit?.getOrderDetail(o.id),
              ),
            ],
          ],
          SizedBox(height: AppSpacing.md12),
          _buildParticipantCard(
            participant: isSupplier ? o.buyer : o.seller,
            sectionLabel: isSupplier
                ? 'orders.participant_buyer'.tr()
                : 'orders.participant_supplier'.tr(),
            verifiedLabel: isSupplier
                ? 'orders.buyer_verified'.tr()
                : 'orders.supplier_verified'.tr(),
            onTap: isSupplier
                ? null
                : () => context.push(
                      '/supplier/${o.seller.id}',
                      extra: {'name': o.seller.name},
                    ),
          ),
          SizedBox(height: AppSpacing.md12),
          _buildSection('orders.section_basic_info'.tr(), [
            _infoRow('orders.field_order_number'.tr(), o.displayOrderNumber),
            if (_batchOrderIds.length > 1)
              _infoRow('orders.field_internal_store_number'.tr(), o.orderNumber),
            _infoRow(
              'orders.field_order_date'.tr(),
              DateFormat('dd MMM yyyy, HH:mm').format(o.createdAt),
            ),
          ]),
          SizedBox(height: AppSpacing.md12),
          _buildShippingSection(o),
          if (o.status == 'PENDING') ...[
            SizedBox(height: AppSpacing.md12),
            _buildAwaitingPaymentBanner(o),
          ],
          if (o.status != 'PENDING' &&
              o.shipment != null &&
              o.shipment?.vesselName != null &&
              !isPendingPaymentVesselPlaceholder(o.shipment!.vesselName)) ...[
            SizedBox(height: AppSpacing.md12),
            _buildSection('orders.section_shipping_status'.tr(), [
              _infoRow('orders.field_vessel'.tr(), o.shipment!.vesselName!),
              if (o.shipment?.originHub != null)
                _infoRow('orders.field_origin_hub'.tr(), o.shipment!.originHub!),
              if (o.shipment?.destinationHub != null)
                _infoRow('orders.field_destination_hub'.tr(), o.shipment!.destinationHub!),
              if (o.shipment?.currentLat != null && o.shipment?.currentLng != null) ...[
                SizedBox(height: AppSpacing.sm10),
                OrderTrackingMap(
                  lat: (o.shipment!.currentLat as num).toDouble(),
                  lng: (o.shipment!.currentLng as num).toDouble(),
                ),
                SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () => url_launcher.launchUrl(
                    Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${o.shipment!.currentLat},${o.shipment!.currentLng}',
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.mapPin, color: AppColors.primary, size: 16.sp),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'orders.open_google_maps'.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ]),
          ],
          SizedBox(height: AppSpacing.md12),
          _buildSection('orders.section_order_items'.tr(), [
            ...o.items.map((item) => _itemRow(item, currencyFormatter)),
          ]),
          if (o.specifications != null && o.specifications!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md12),
            _buildSection('orders.section_agreed_specs'.tr(), [
              Text(
                o.specifications!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ]),
          ],
          SizedBox(height: AppSpacing.md12),
          _buildSection('orders.section_payment_breakdown'.tr(), [
            _priceRow('orders.field_subtotal'.tr(), o.subtotal, currencyFormatter),
            _priceRow('orders.field_platform_fee'.tr(), o.platformFee, currencyFormatter),
            if (o.logisticsFee > 0)
              _priceRow('orders.field_shipping_fee'.tr(), o.logisticsFee, currencyFormatter),
            _priceRow('orders.field_vat'.tr(), o.vatAmount, currencyFormatter),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: const Divider(color: AppColors.grey100),
            ),
            _priceRow(
              'orders.field_total_payment'.tr(),
              o.totalAmount,
              currencyFormatter,
              isBold: true,
            ),
          ]),
          SizedBox(height: AppSpacing.md12),
          _buildPaymentStatusSection(context, o),
          SizedBox(height: AppSpacing.xl),
          _buildActions(context),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildAwaitingPaymentBanner(OrderEntity o) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.clock, size: 18.sp, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.awaiting_payment_title'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'orders.awaiting_payment_body'.tr(
                    namedArgs: {'orderNumber': o.orderNumber},
                  ),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _paymentStatusLabel(OrderEntity o) {
    return orderPaymentStatusLabel(o.transaction?.paymentStatus);
  }

  Color _paymentStatusColor(OrderEntity o) {
    final status = o.transaction?.paymentStatus?.toUpperCase();
    switch (status) {
      case 'SUCCESS':
        return AppColors.success;
      case 'PENDING':
        return AppColors.warning;
      case 'FAILED':
      case 'EXPIRED':
        return AppColors.error;
      case 'REFUNDED':
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }

  String _escrowStatusLabel(OrderEntity o) {
    return orderEscrowStatusLabel(o.transaction?.status);
  }

  Widget _buildPaymentStatusSection(BuildContext context, OrderEntity o) {
    final tx = o.transaction;
    final paymentLabel = _paymentStatusLabel(o);
    final paymentColor = _paymentStatusColor(o);
    final channelName = _resolvedChannelName(o);
    final hasMethod = _hasPaymentMethodSelected(o);
    final paidAt = tx?.paidAt;
    final isPendingOrder = o.status == 'PENDING';

    final isPaymentExpired =
        tx?.paymentStatus?.toUpperCase() == 'EXPIRED';

    return _buildSection('orders.section_payment_status'.tr(), [
      if (tx?.paymentStatus?.toUpperCase() == 'PENDING' ||
          isPaymentExpired) ...[
        PaymentExpiryBanner(
          pendingPayment: _pendingPayment ?? o.pendingPayment,
          orderCreatedAt: o.createdAt,
          paymentStatus: tx?.paymentStatus,
        ),
        SizedBox(height: AppSpacing.sm10),
      ],
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md12),
        decoration: BoxDecoration(
          color: paymentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: paymentColor.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  tx?.paymentStatus?.toUpperCase() == 'SUCCESS'
                      ? LucideIcons.circleCheck
                      : isPaymentExpired
                          ? LucideIcons.circleX
                          : LucideIcons.creditCard,
                  size: 20.sp,
                  color: paymentColor,
                ),
                SizedBox(width: AppSpacing.sm10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentLabel,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          color: paymentColor,
                        ),
                      ),
                      if (tx != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'orders.escrow_prefix'.tr(
                            namedArgs: {'status': _escrowStatusLabel(o)},
                          ),
                          style: AppTextStyles.caption(
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Metode + Ubah dalam kartu yang sama (tidak duplikat section).
            if (hasMethod) ...[
              SizedBox(height: AppSpacing.md12),
              Divider(height: 1, color: paymentColor.withValues(alpha: 0.2)),
              SizedBox(height: AppSpacing.md12),
              Row(
                children: [
                  Icon(LucideIcons.wallet, size: 16.sp, color: AppColors.primary),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'orders.field_method'.tr(),
                          style: AppTextStyles.caption(
                              color: AppColors.textSecondary),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          channelName ?? 'orders.payment_fallback'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPendingOrder)
                    TextButton(
                      onPressed: () => _pickPaymentMethod(context, o),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'orders.change_method'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ] else if (isPendingOrder) ...[
              SizedBox(height: AppSpacing.md12),
              OutlinedButton.icon(
                onPressed: () => _pickPaymentMethod(context, o),
                icon: Icon(LucideIcons.wallet, size: 16.sp),
                label: Text(
                  'orders.pick_payment_method'.tr(),
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5)),
                  minimumSize: Size(double.infinity, 40.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      if (paidAt != null)
        _infoRow(
          'orders.field_paid_at'.tr(),
          DateFormat('dd MMM yyyy, HH:mm').format(paidAt),
        ),
      if (tx == null && !hasMethod)
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            'orders.payment_not_init_hint'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textHint,
              height: 1.4,
            ),
          ),
        ),
    ]);
  }

  Widget _buildActions(BuildContext context) {
    final o = _order!;
    final authState = context.read<AuthCubit>().state;
    final currentUser = authState.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );

    if (currentUser == null) return const SizedBox.shrink();

    final isBuyer = currentUser.role == 'BUYER';
    final isSupplier = currentUser.role == 'SUPPLIER';
    final isPendingPayment = o.status == 'PENDING';

    return Column(
      children: [
        // PENDING: Unduh Invoice (kiri) + Lanjut bayar (kanan) sejajar.
        if (isBuyer && isPendingPayment) ...[
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md12),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'orders.action_download_invoice'.tr(),
                    isOutlined: true,
                    backgroundColor: AppColors.primary,
                    onPressed: () =>
                        InvoiceExportHelper.exportOrder(context, o),
                  ),
                ),
                SizedBox(width: AppSpacing.sm10),
                Expanded(
                  child: CustomButton(
                    text: 'orders.action_continue_payment'.tr(),
                    useGradient: true,
                    onPressed: _hasPaymentMethodSelected(o) && !_paymentBusy
                        ? () => _continueToPayment(context, o)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (!isPendingPayment && o.status != 'CANCELLED')
          _actionButton(
            'orders.action_download_invoice'.tr(),
            AppColors.primary,
            () => InvoiceExportHelper.exportOrder(context, o),
            isOutlined: true,
          ),
        // Supplier / non-buyer di PENDING: tetap bisa unduh invoice penuh.
        if (!isBuyer && isPendingPayment && o.status != 'CANCELLED')
          _actionButton(
            'orders.action_download_invoice'.tr(),
            AppColors.primary,
            () => InvoiceExportHelper.exportOrder(context, o),
            isOutlined: true,
          ),
        if (isBuyer &&
            (o.status == 'SHIPPED' || o.status == 'PROCESSING')) ...[
          if (o.status == 'SHIPPED')
            _actionButton(
              'orders.action_confirm_received'.tr(),
              AppColors.secondary,
              () => _confirmReleaseEscrow(context),
              useGradient: true,
            ),
          _actionButton(
            'orders.action_file_dispute'.tr(),
            AppColors.error,
            () => _showDisputeDialog(context),
            isOutlined: true,
          ),
        ],
        // Buyer Actions (Completed Order)
        if (isBuyer && o.status == 'COMPLETED') ...[
          if (o.review == null)
            _actionButton('orders.action_write_review'.tr(), AppColors.primary, () async {
              if (o.items.isNotEmpty) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteReviewPage(
                      productId: o.items.first.productId,
                      orderId: o.id,
                      productName: o.items.first.productName,
                      thumbnailUrl: o.items.first.thumbnailUrl,
                      shopName: o.seller.name,
                      shopRegency: o.seller.regency,
                      shopAvatar: o.seller.avatarUrl,
                      isShopVerified: o.seller.isVerified,
                    ),
                  ),
                );
                if (result != null) {
                  if (result is Map) {
                    setState(() {
                      _order = _order!.copyWith(
                        review: OrderReviewEntity(
                          id: 'new',
                          rating: result['rating'],
                          comment: result['comment'],
                        ),
                      );
                    });
                  }
                  _pageOrderCubit?.getOrderDetail(widget.orderId);
                }
              }
            })
          else ...[
            SizedBox(height: AppSpacing.md12),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.check,
                                  color: AppColors.primary,
                                  size: 12.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'orders.review_verified'.tr(),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WriteReviewPage(
                                productId: o.items.first.productId,
                                orderId: o.id,
                                productName: o.items.first.productName,
                                thumbnailUrl: o.items.first.thumbnailUrl,
                                shopName: o.seller.name,
                                shopRegency: o.seller.regency,
                                shopAvatar: o.seller.avatarUrl,
                                isShopVerified: o.seller.isVerified,
                                reviewId: o.review!.id,
                                initialRating: o.review!.rating,
                                initialComment: o.review!.comment,
                              ),
                            ),
                          );
                          if (result != null) {
                            if (result is Map) {
                              setState(() {
                                _order = _order!.copyWith(
                                  review:
                                      _order!.review?.copyWith(
                                        rating: result['rating'],
                                        comment: result['comment'],
                                      ) ??
                                      OrderReviewEntity(
                                        id: 'new',
                                        rating: result['rating'],
                                        comment: result['comment'],
                                      ),
                                );
                              });
                            }
                            _pageOrderCubit?.getOrderDetail(
                              widget.orderId,
                            );
                          }
                        },
                        icon: Icon(LucideIcons.pencil, size: 14.sp),
                        label: Text(
                          'orders.change_method'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md12),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        LucideIcons.star,
                        color: index < o.review!.rating
                            ? AppColors.warning
                            : AppColors.grey200,
                        size: 18.sp,
                        fill: index < o.review!.rating ? 1 : 0,
                      );
                    }),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.review!.comment,
                        maxLines: _showFullReview ? null : 3,
                        overflow: _showFullReview
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textPrimary,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (o.review!.comment.length > 100)
                        GestureDetector(
                          onTap: () => setState(
                            () => _showFullReview = !_showFullReview,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: AppSpacing.sm),
                            child: Text(
                              _showFullReview
                                  ? 'orders.review_show_less'.tr()
                                  : 'orders.review_show_more'.tr(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: AppSpacing.md12),
          _buildPartnershipInviteCard(context, o),
        ],
        if (isSupplier && (o.status == 'PROCESSING' || o.status == 'SHIPPED'))
          _actionButton(
            'orders.action_update_shipping'.tr(),
            AppColors.primary,
            () => _showUpdateTrackingDialog(context, o),
          ),
        if (isSupplier &&
            o.status == 'PROCESSING' &&
            (o.shipment?.courierCode?.toLowerCase() == 'bisa_express' ||
                o.orderShipping?.courierCode?.toLowerCase() == 'bisa_express'))
          _actionButton(
            'orders.bisa_express_request_pickup'.tr(),
            AppColors.secondary,
            _requestPickupBusy ? null : () => _requestBisaExpressPickup(context, o),
            useGradient: true,
          ),
        if (o.status.toUpperCase() == 'DISPUTED') ...[
          _actionButton(
            'orders.action_refresh_dispute'.tr(),
            AppColors.primary,
            () => _reloadOrderDetail(),
            isOutlined: true,
          ),
        ],
      ],
    );
  }

  void _showSupplierDisputeResponseDialog(BuildContext context) {
    final responseController = TextEditingController();
    final evidencePaths = <String>[];

    showDialog(
      context: context,
      builder: (dContext) => StatefulBuilder(
        builder: (dContext, setDialogState) {
          final viewInsets = MediaQuery.viewInsetsOf(dContext);
          return AnimatedPadding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            duration: const Duration(milliseconds: 150),
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'orders.dispute_response_title'.tr(),
                        style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'orders.dispute_response_hint'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: AppSpacing.section),
                      CustomTextField(
                        label: 'orders.dispute_response_label'.tr(),
                        hint: 'orders.dispute_min_chars_hint'.tr(),
                        controller: responseController,
                        maxLines: 4,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        'orders.dispute_evidence_label'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          ...evidencePaths.map(
                            (path) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.button),
                                  child: Image.file(
                                    File(path),
                                    width: 64.w,
                                    height: 64.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => setDialogState(
                                      () => evidencePaths.remove(path),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        LucideIcons.x,
                                        size: 14.sp,
                                        color: AppColors.surface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (evidencePaths.length < 5)
                            InkWell(
                              onTap: () async {
                                final image = await _imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 75,
                                );
                                if (image != null) {
                                  setDialogState(
                                    () => evidencePaths.add(image.path),
                                  );
                                }
                              },
                              child: Container(
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.grey200),
                                  borderRadius: BorderRadius.circular(AppRadius.button),
                                ),
                                child: const Icon(
                                  LucideIcons.camera,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      CustomButton(
                        text: 'orders.send'.tr(),
                        height: 46.h,
                        onPressed: () {
                          if (responseController.text.trim().length >= 10) {
                            Navigator.pop(dContext);
                            _pageOrderCubit?.respondToDispute(
                              widget.orderId,
                              responseController.text.trim(),
                              List<String>.from(evidencePaths),
                            );
                          }
                        },
                      ),
                      SizedBox(height: AppSpacing.sm),
                      CustomButton(
                        text: 'orders.cancel'.tr(),
                        height: 46.h,
                        isOutlined: true,
                        onPressed: () => Navigator.pop(dContext),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton(
    String title,
    Color color,
    VoidCallback? onTap, {
    bool isOutlined = false,
    bool useGradient = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md12),
      child: CustomButton(
        text: title,
        onPressed: onTap,
        isOutlined: isOutlined,
        useGradient: useGradient,
        backgroundColor: isOutlined ? color : color,
      ),
    );
  }

  Widget _buildPartnershipInviteCard(BuildContext context, OrderEntity order) {
    final negotiationId = order.negotiationId;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.md12),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  LucideIcons.handshake,
                  color: AppColors.success,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Text(
                  'orders.partnership_invite_title'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'orders.partnership_invite_subtitle'.tr(
              namedArgs: {'name': order.seller.name},
            ),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.md12),
          CustomButton(
            text: 'orders.partnership_invite_cta'.tr(),
            backgroundColor: AppColors.success,
            onPressed: () {
              context.push(
                '/partnerships/create/${order.seller.id}',
                extra: {
                  'name': order.seller.name,
                  if (negotiationId != null) 'negotiationId': negotiationId,
                },
              );
            },
          ),
          if (negotiationId != null) ...[
            SizedBox(height: AppSpacing.sm10),
            CustomButton(
              text: 'orders.partnership_send_chat_cta'.tr(),
              isOutlined: true,
              backgroundColor: AppColors.success,
              onPressed: () => _sendPartnershipProposalFromOrder(context, order),
            ),
            SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () => context.push('/negotiation/$negotiationId'),
              icon: Icon(LucideIcons.messageSquare, size: 16.sp),
              label: Text('orders.partnership_open_chat_cta'.tr()),
              style: TextButton.styleFrom(foregroundColor: AppColors.success),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendPartnershipProposalFromOrder(
    BuildContext context,
    OrderEntity order,
  ) async {
    final negotiationId = order.negotiationId;
    if (negotiationId == null) return;

    final existing =
        await PartnershipPdfExportHelper.findPartnershipWithSupplier(
      order.seller.id,
    );
    if (!context.mounted) return;

    if (existing != null &&
        existing.status != 'REJECTED' &&
        existing.status != 'TERMINATED') {
      await PartnershipPdfExportHelper.showSendProposalSheet(
        context,
        negotiationId: negotiationId,
        partnership: existing,
      );
      return;
    }

    // Belum ada kontrak — arahkan buat dulu (dengan kirim ke chat).
    if (!context.mounted) return;
    context.push(
      '/partnerships/create/${order.seller.id}',
      extra: {
        'name': order.seller.name,
        'negotiationId': negotiationId,
      },
    );
  }

  void _confirmReleaseEscrow(BuildContext context) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'orders.confirm_title'.tr(),
      message: 'orders.confirm_receive_message'.tr(),
      confirmText: 'orders.confirm_receive_yes'.tr(),
    );
    if (confirmed == true && context.mounted) {
      _pageOrderCubit?.releaseEscrow(widget.orderId);
    }
  }

  Future<void> _pollPaymentStatus() async {
    final cubit = _pageOrderCubit;
    if (cubit == null) return;
    await cubit.pollPaymentStatus(widget.orderId);
    if (!mounted) return;
    final order = await cubit.getOrderDetail(widget.orderId, silent: true);
    if (order != null && mounted) {
      _applyOrder(order);
    }
  }

  /// Hanya pilih metode — belum panggil backend / Xendit.
  Future<void> _pickPaymentMethod(BuildContext context, OrderEntity order) async {
    final choice = await PaymentMethodPickerSheet.show(
      context,
      amount: order.totalAmount,
      initialCode: _selectedChannelCode,
    );
    if (choice == null || !mounted) return;
    setState(() {
      _selectedChannelCode = choice.code;
      _selectedChannelName = choice.name;
    });
  }

  /// Inisialisasi pembayaran di backend, lalu buka instruksi / webview.
  Future<void> _continueToPayment(BuildContext context, OrderEntity order) async {
    final channelCode = _resolvedChannelCode(order);
    if (channelCode == null || channelCode.isEmpty || _paymentBusy) return;

    final initializedCode = _pendingPayment?['channelCode']?.toString() ??
        order.transaction?.paymentChannelCode;
    final sameChannel = initializedCode != null &&
        initializedCode.toUpperCase() == channelCode.toUpperCase();

    if (_pendingPayment != null &&
        sameChannel &&
        paymentInstructionsReady(_pendingPayment!)) {
      await _openPaymentInstructions(_pendingPayment!);
      return;
    }

    // Regenerate jika VA/QR kosong atau metode diganti.
    final forceNew = initializedCode != null &&
        (!sameChannel ||
            _pendingPayment == null ||
            !paymentInstructionsReady(_pendingPayment!));

    setState(() => _paymentBusy = true);
    try {
      final Either<Failure, Map<String, dynamic>> result;
      if (_batchOrderIds.length > 1) {
        result = await sl<OrderRepository>().initializeBatchPayment(
          _batchOrderIds,
          channelCode,
          forceNew: forceNew,
        );
      } else {
        result = await sl<OrderRepository>().initializePayment(
          order.id,
          channelCode,
          forceNew: forceNew,
        );
      }
      if (!mounted) return;

      await result.fold(
        (failure) async {
          showBisaSnackBar(
            context,
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.textOnPrimary),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    failure.message.localizedFailure,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          );
        },
        (data) async {
          final paymentMap = Map<String, dynamic>.from(data);
          if (!mounted) return;
          setState(() {
            _pendingPayment = paymentMap;
            _paymentBusy = false;
          });
          await _navigateAfterPaymentInit(paymentMap);
        },
      );
    } finally {
      if (mounted) setState(() => _paymentBusy = false);
    }
  }

  void _showDisputeDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final descController = TextEditingController();
    final evidencePaths = <String>[];

    showDialog(
      context: context,
      builder: (dContext) => StatefulBuilder(
        builder: (dContext, setDialogState) {
          final viewInsets = MediaQuery.viewInsetsOf(dContext);
          return AnimatedPadding(
            padding: EdgeInsets.only(bottom: viewInsets.bottom),
            duration: const Duration(milliseconds: 150),
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'orders.file_dispute_title'.tr(),
                        style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: AppSpacing.section),
                      CustomTextField(
                        label: 'orders.dispute_reason_label'.tr(),
                        hint: 'orders.dispute_min_chars_hint'.tr(),
                        controller: reasonController,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      CustomTextField(
                        label: 'orders.dispute_description_label'.tr(),
                        hint: 'orders.dispute_description_hint'.tr(),
                        controller: descController,
                        maxLines: 3,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        'orders.dispute_evidence_label'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          ...evidencePaths.map(
                            (path) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.button),
                                  child: Image.file(
                                    File(path),
                                    width: 64.w,
                                    height: 64.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setDialogState(
                                        () => evidencePaths.remove(path),
                                      );
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        LucideIcons.x,
                                        size: 14.sp,
                                        color: AppColors.surface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (evidencePaths.length < 5)
                            InkWell(
                              onTap: () async {
                                final image = await _imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 75,
                                );
                                if (image != null) {
                                  setDialogState(
                                    () => evidencePaths.add(image.path),
                                  );
                                }
                              },
                              child: Container(
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.grey200),
                                  borderRadius: BorderRadius.circular(AppRadius.button),
                                ),
                                child: const Icon(
                                  LucideIcons.camera,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      CustomButton(
                        text: 'orders.send'.tr(),
                        height: 46.h,
                        onPressed: () {
                          if (reasonController.text.trim().length >= 10) {
                            Navigator.pop(dContext);
                            _pageOrderCubit?.raiseDispute(
                              widget.orderId,
                              reasonController.text.trim(),
                              descController.text.trim(),
                              List<String>.from(evidencePaths),
                            );
                          }
                        },
                      ),
                      SizedBox(height: AppSpacing.sm),
                      CustomButton(
                        text: 'orders.cancel'.tr(),
                        height: 46.h,
                        isOutlined: true,
                        onPressed: () => Navigator.pop(dContext),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateTrackingDialog(BuildContext context, OrderEntity order) {
    final shipment = order.shipment;
    final vesselController = TextEditingController(
      text: shipment?.vesselName ?? 'orders.default_fleet_name'.tr(),
    );
    final awbController = TextEditingController(text: shipment?.awbNumber ?? '');
    final courierController = TextEditingController(
      text: shipment?.courierCode ?? '',
    );
    final originController = TextEditingController(text: shipment?.originHub ?? '');
    final destController = TextEditingController(
      text: shipment?.destinationHub ?? '',
    );

    showDialog(
      context: context,
      builder: (dContext) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'orders.update_shipping_title'.tr(),
                  style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
                ),
                if (shipment?.trackingNumber?.isNotEmpty ?? false) ...[
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'orders.tracking_bisa_label'.tr(
                      namedArgs: {'tracking': shipment!.trackingNumber!},
                    ),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.section),
                CustomTextField(
                  label: 'orders.tracking_fleet_label'.tr(),
                  hint: 'orders.tracking_fleet_hint'.tr(),
                  controller: vesselController,
                ),
                SizedBox(height: AppSpacing.sm10),
                CustomTextField(
                  label: 'orders.tracking_awb_label'.tr(),
                  hint: 'orders.tracking_awb_hint'.tr(),
                  controller: awbController,
                ),
                SizedBox(height: AppSpacing.sm10),
                CustomTextField(
                  label: 'orders.tracking_courier_code_label'.tr(),
                  hint: 'orders.tracking_courier_code_hint'.tr(),
                  controller: courierController,
                ),
                SizedBox(height: AppSpacing.sm10),
                CustomTextField(
                  label: 'orders.tracking_origin_hub_label'.tr(),
                  hint: 'orders.tracking_optional_hint'.tr(),
                  controller: originController,
                ),
                SizedBox(height: AppSpacing.sm10),
                CustomTextField(
                  label: 'orders.tracking_dest_hub_label'.tr(),
                  hint: 'orders.tracking_optional_hint'.tr(),
                  controller: destController,
                ),
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'orders.update'.tr(),
                  height: 46.h,
                  onPressed: () async {
                    final vessel = vesselController.text.trim();
                    if (vessel.length < 3) {
                      showBisaSnackBar(
                        context,
                        content: Text('orders.tracking_fleet_min_error'.tr()),
                      );
                      return;
                    }
                    Navigator.pop(dContext);
                    if (!mounted) return;
                    _pageOrderCubit?.updateTracking(widget.orderId, {
                      'vesselName': vessel,
                      if (awbController.text.trim().isNotEmpty)
                        'awbNumber': awbController.text.trim(),
                      if (courierController.text.trim().isNotEmpty)
                        'courierCode': courierController.text.trim(),
                      if (originController.text.trim().isNotEmpty)
                        'originHub': originController.text.trim(),
                      if (destController.text.trim().isNotEmpty)
                        'destinationHub': destController.text.trim(),
                    });
                  },
                ),
                SizedBox(height: AppSpacing.sm),
                CustomButton(
                  text: 'orders.cancel'.tr(),
                  height: 46.h,
                  isOutlined: true,
                  onPressed: () => Navigator.pop(dContext),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBatchCheckoutBanner(OrderEntity o) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => context.push('/order-batch/${o.id}'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md12),
          child: Row(
            children: [
              Icon(LucideIcons.layers, size: 18.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Text(
                  'orders.batch_checkout_banner'.tr(
                    namedArgs: {'count': '${_batchOrderIds.length}'},
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18.sp, color: AppColors.grey400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(OrderEntity o) {
    Color statusColor;
    IconData statusIcon;
    switch (o.status.toUpperCase()) {
      case 'DISPUTED':
        statusColor = AppColors.error;
        statusIcon = LucideIcons.shieldAlert;
        break;
      case 'REFUNDED':
        statusColor = AppColors.warning;
        statusIcon = LucideIcons.undo2;
        break;
      case 'COMPLETED':
      case 'DELIVERED':
        statusColor = AppColors.success;
        statusIcon = LucideIcons.check;
        break;
      case 'CANCELLED':
        statusColor = AppColors.grey600;
        statusIcon = LucideIcons.x;
        break;
      case 'SHIPPED':
        statusColor = AppColors.info;
        statusIcon = LucideIcons.truck;
        break;
      default:
        statusColor = AppColors.primary;
        statusIcon = LucideIcons.package;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm10),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: AppColors.textOnPrimary, size: 24.sp),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.status_label'.tr(),
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _orderStatusLabel(o),
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _orderStatusLabel(OrderEntity o) {
    if (o.status.toUpperCase() == 'DISPUTED') {
      return o.dispute != null
          ? disputeStatusLabel(o.dispute!)
          : orderStatusLabel('DISPUTED');
    }
    if (o.status.toUpperCase() == 'PENDING') {
      return 'orders.status.pending_payment'.tr();
    }
    return orderStatusLabel(o.status);
  }


  Widget _buildParticipantCard({
    required OrderParticipantEntity participant,
    required String sectionLabel,
    required String verifiedLabel,
    VoidCallback? onTap,
  }) {
    final content = Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          BisaAvatar(
            imageUrl: participant.avatarUrl,
            radius: 22.r,
            fallbackIcon: LucideIcons.user,
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        participant.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (participant.isVerified) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        LucideIcons.badgeCheck,
                        color: AppColors.info,
                        size: 14.sp,
                      ),
                    ],
                  ],
                ),
                if (participant.regency != null)
                  Text(
                    participant.regency!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                if (participant.isVerified)
                  Row(
                    children: [
                      Icon(
                        LucideIcons.shieldCheck,
                        color: AppColors.primary,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        verifiedLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.grey400,
              size: 20.sp,
            ),
        ],
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }

  Widget _buildShippingSection(OrderEntity o) {
    final snap = o.shippingAddressSnapshot;
    final rows = <Widget>[];

    if (snap != null) {
      final recipient = snap['recipient']?.toString();
      final phone = snap['phone']?.toString();
      final email = snap['email']?.toString();
      final address = snap['address']?.toString();
      final regency = snap['regency']?.toString();
      final province = snap['province']?.toString();
      final zipCode = snap['zipCode']?.toString();

      if (recipient != null && recipient.isNotEmpty) {
        rows.add(_infoRow('orders.field_recipient'.tr(), recipient));
      }
      if (phone != null && phone.isNotEmpty) {
        rows.add(_infoRow('orders.field_phone'.tr(), phone));
      }
      if (email != null && email.isNotEmpty) {
        rows.add(_infoRow('orders.field_email'.tr(), email));
      }
      if (address != null && address.isNotEmpty) {
        rows.add(
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.field_full_address'.tr(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      final locationParts = [
        if (regency != null && regency.isNotEmpty) regency,
        if (province != null && province.isNotEmpty) province,
        if (zipCode != null && zipCode.isNotEmpty) zipCode,
      ];
      if (locationParts.isNotEmpty) {
        rows.add(_infoRow('orders.field_region'.tr(), locationParts.join(', ')));
      }

      final logistics = snap['logistics'];
      if (logistics is Map) {
        final courier = logistics['courierCode']?.toString();
        final service = logistics['verifiedService']?.toString() ??
            logistics['serviceName']?.toString();
        final destinationLabel = logistics['destinationLabel']?.toString();
        final etd = logistics['etd']?.toString();
        final costRaw = logistics['cost'];

        if (courier != null && courier.isNotEmpty) {
          rows.add(_infoRow('orders.field_courier'.tr(), courier.toUpperCase()));
        }
        if (service != null && service.isNotEmpty) {
          rows.add(_infoRow('orders.field_service'.tr(), service));
        }
        if (destinationLabel != null && destinationLabel.isNotEmpty) {
          rows.add(_infoRow('orders.field_shipping_destination'.tr(), destinationLabel));
        }
        if (etd != null && etd.isNotEmpty) {
          rows.add(_infoRow('orders.field_estimate'.tr(), etd));
        }
        if (costRaw != null) {
          final cost = double.tryParse(costRaw.toString());
          if (cost != null) {
            final formattedCost = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(cost);
            rows.add(_infoRow('orders.field_shipping_fee'.tr(), formattedCost));
          }
        }
      }
    }

    final orderShipping = o.orderShipping;
    if (orderShipping != null) {
      if (orderShipping.courierCode != null &&
          orderShipping.courierCode!.isNotEmpty) {
        rows.add(_infoRow('orders.field_courier'.tr(), orderShipping.courierCode!.toUpperCase()));
      }
      if (orderShipping.serviceName != null && orderShipping.serviceName!.isNotEmpty) {
        rows.add(_infoRow('orders.field_service'.tr(), orderShipping.serviceName!));
      }
      if (orderShipping.destinationLabel != null &&
          orderShipping.destinationLabel!.isNotEmpty) {
        rows.add(_infoRow('orders.field_destination'.tr(), orderShipping.destinationLabel!));
      }
      if (orderShipping.shippingCost != null) {
        final formattedCost = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(orderShipping.shippingCost);
        rows.add(_infoRow('orders.field_shipping_fee'.tr(), formattedCost));
      }
      if (orderShipping.etd != null && orderShipping.etd!.isNotEmpty) {
        rows.add(_infoRow('orders.field_etd'.tr(), orderShipping.etd!));
      }
    }

    final shipment = o.shipment;
    if (shipment != null) {
      final tracking = shipment.trackingNumber?.trim();
      if (tracking != null && tracking.isNotEmpty) {
        rows.add(_infoRow('orders.field_bisa_tracking'.tr(), tracking));
      }
      if (shipment.awbNumber != null && shipment.awbNumber!.isNotEmpty) {
        rows.add(_infoRow('orders.field_courier_awb'.tr(), shipment.awbNumber!));
      }
      if (shipment.courierCode != null && shipment.courierCode!.isNotEmpty) {
        rows.add(_infoRow('orders.field_courier'.tr(), shipment.courierCode!.toUpperCase()));
      }
      if (shipment.deliveryStatus != null && shipment.deliveryStatus!.isNotEmpty) {
        rows.add(_infoRow('orders.field_delivery_status'.tr(), shipment.deliveryStatus!));
      }
      if (shipment.lastTrackedAt != null) {
        rows.add(
          _infoRow(
            'orders.field_last_sync'.tr(),
            DateFormat('dd MMM yyyy, HH:mm').format(shipment.lastTrackedAt!),
          ),
        );
      }
      if (shipment.awbNumber != null &&
          shipment.awbNumber!.isNotEmpty &&
          shipment.courierCode != null &&
          shipment.courierCode!.isNotEmpty) {
        final isBisaExpress =
            shipment.courierCode!.toLowerCase() == 'bisa_express';
        rows.add(
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Column(
              children: [
                if (isBisaExpress) ...[
                  OutlinedButton.icon(
                    onPressed: () => BisaExpressTimelineSheet.show(
                      context,
                      awb: shipment.awbNumber!,
                    ),
                    icon: Icon(LucideIcons.route, size: 15.sp),
                    label: Text(
                      'orders.bisa_express_view_timeline'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      minimumSize: Size(double.infinity, 42.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                ],
                OutlinedButton.icon(
                  onPressed:
                      _trackingSyncBusy ? null : () => _syncTrackingFromRajaOngkir(o),
                  icon: _trackingSyncBusy
                      ? SizedBox(
                          width: AppSpacing.section,
                          height: AppSpacing.section,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(LucideIcons.refreshCcw, size: 15.sp),
                  label: Text(
                    _trackingSyncBusy
                        ? 'orders.tracking_syncing'.tr()
                        : isBisaExpress
                            ? 'orders.tracking_sync_button_bisa'.tr()
                            : 'orders.tracking_sync_button'.tr(),
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    minimumSize: Size(double.infinity, 42.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (rows.isEmpty) {
      rows.add(
        Text(
          'orders.shipping_address_unavailable'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      );
    }

    return _buildSection('orders.section_shipping_address'.tr(), rows);
  }

  Future<void> _requestBisaExpressPickup(
    BuildContext context,
    OrderEntity order,
  ) async {
    setState(() => _requestPickupBusy = true);
    try {
      await sl<BisaExpressRemoteDataSource>().requestPickup(orderId: order.id);
      if (!mounted) return;
      showBisaSnackBar(
        context,
        content: Text('orders.bisa_express_request_pickup_success'.tr()),
        backgroundColor: AppColors.success,
      );
      await _reloadOrderDetail(silent: true);
    } catch (e) {
      if (!mounted) return;
      showBisaSnackBar(
        context,
        content: Text('orders.bisa_express_request_pickup_failed'.tr()),
        backgroundColor: AppColors.error,
      );
    } finally {
      if (mounted) setState(() => _requestPickupBusy = false);
    }
  }

  Future<void> _syncTrackingFromRajaOngkir(OrderEntity order) async {
    final shipment = order.shipment;
    final awb = shipment?.awbNumber;
    final courier = shipment?.courierCode;
    if (awb == null || awb.isEmpty || courier == null || courier.isEmpty) {
      showBisaSnackBar(
        context,
        content: Text('orders.tracking_sync_no_awb'.tr()),
        backgroundColor: AppColors.warning,
      );
      return;
    }

    setState(() => _trackingSyncBusy = true);
    try {
      final result = await _pageOrderCubit?.syncTrackingFromRajaOngkir(
        orderId: order.id,
        awb: awb,
        courier: courier,
      );
      if (!mounted) return;
      if (result == null) {
        showBisaSnackBar(
          context,
          content: Text('orders.tracking_sync_failed'.tr()),
          backgroundColor: AppColors.error,
        );
        return;
      }
      await _reloadOrderDetail(silent: true);
      if (!mounted) return;
      showBisaSnackBar(
        context,
        content: Text('orders.tracking_sync_success'.tr()),
        backgroundColor: AppColors.success,
      );
      if (courier.toLowerCase() == 'bisa_express') {
        await BisaExpressTimelineSheet.show(context, awb: awb);
      }
    } finally {
      if (mounted) {
        setState(() => _trackingSyncBusy = false);
      }
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(OrderItemEntity item, NumberFormat formatter) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push('/product/${item.productId}'),
            child: Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.grey100),
              ),
              child: item.thumbnailUrl != null &&
                      item.thumbnailUrl!.trim().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: BisaNetworkImage(
                        imageUrl: item.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      LucideIcons.image,
                      color: AppColors.grey300,
                      size: 20.sp,
                    ),
            ),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.push('/product/${item.productId}'),
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_order != null) ...[
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () => context.push(
                      '/supplier/${_order!.seller.id}',
                      extra: {'name': _order!.seller.name},
                    ),
                    child: Row(
                      children: [
                        Text(
                          _order!.seller.name,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_order!.seller.isVerified) ...[
                          SizedBox(width: 4.w),
                          Icon(LucideIcons.badgeCheck,
                              color: AppColors.info, size: 10.sp),
                        ],
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 2.h),
                Text(
                  '${item.quantity.toInt()} x ${formatter.format(item.pricePerUnit)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            formatter.format(item.subtotal),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    double price,
    NumberFormat formatter, {
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          Flexible(
            child: Text(
              formatter.format(price),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: isBold ? 15.sp : 13.sp,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
