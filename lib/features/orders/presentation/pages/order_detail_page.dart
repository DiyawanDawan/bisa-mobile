import 'dart:io';

import 'package:dartz/dartz.dart' hide State;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/core/errors/failures.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/features/orders/domain/repositories/order_repository.dart';
import 'package:mobile_bisa/features/orders/presentation/bloc/order_cubit.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/payment_result_utils.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/order_dispute_section.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_expiry_banner.dart';
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

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  /// Set `true` setelah checkout dari keranjang — otomatis buka picker metode (bukan bayar langsung).
  final bool autoStartPayment;

  const OrderDetailPage({
    super.key,
    required this.orderId,
    this.autoStartPayment = false,
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
  bool _showFullReview = false;
  final _imagePicker = ImagePicker();
  /// Cubit lokal dari BlocProvider halaman ini — jangan pakai `context.read`
  /// dari State (itu mengarah ke cubit global di main.dart).
  OrderCubit? _pageOrderCubit;
  List<String> _batchOrderIds = const [];
  bool _batchContextLoaded = false;

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
    _maybeAutoPickPaymentMethod(order);
    _loadBatchPaymentContext(order);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _order == null) return;
      _pickPaymentMethod(context, _order!);
    });
  }

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
        extra: {'url': url, 'title': 'Pembayaran Xendit'},
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
        content: const Text(
          'Pembayaran diinisialisasi, tapi data tidak lengkap. Muat ulang halaman.',
        ),
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
        appBar: const BisaAppBar(
          title: 'Detail Pesanan',
          backgroundColor: Colors.white,
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
                      const Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 8.w),
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
                        color: Colors.black.withValues(alpha: 0.15),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Membuat VA / instruksi bayar...',
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
                padding: EdgeInsets.all(16.w),
                child: const ShimmerListPlaceholder(
                  itemCount: 5,
                  itemHeight: 72,
                ),
              ),
              error: (message) => Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () => context
                            .read<OrderCubit>()
                            .getOrderDetail(widget.orderId),
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                ),
              ),
              loaded: (_) => const SizedBox(),
              orElse: () => Padding(
                padding: EdgeInsets.all(16.w),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(o),
          if (_batchOrderIds.length > 1) ...[
            SizedBox(height: 12.h),
            _buildBatchCheckoutBanner(o),
          ],
          if (o.status.toUpperCase() == 'DISPUTED' && o.dispute != null) ...[
            SizedBox(height: 12.h),
            OrderDisputeSection(
              order: o,
              isBuyer: isBuyer,
              isSupplier: isSupplier,
              onSupplierRespond: isSupplier && o.dispute!.supplierCanRespond
                  ? () => _showSupplierDisputeResponseDialog(context)
                  : null,
            ),
            if (o.negotiationId != null && o.negotiationId!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              CustomButton(
                text: 'Buka chat mediasi',
                useGradient: true,
                onPressed: () => context.push('/negotiation/${o.negotiationId}'),
              ),
            ] else ...[
              SizedBox(height: 12.h),
              CustomButton(
                text: 'Muat chat mediasi',
                useGradient: true,
                onPressed: () => _pageOrderCubit?.getOrderDetail(o.id),
              ),
            ],
          ],
          SizedBox(height: 12.h),
          _buildParticipantCard(
            participant: isSupplier ? o.buyer : o.seller,
            sectionLabel: isSupplier ? 'Pembeli' : 'Supplier',
            verifiedLabel: isSupplier ? 'Pembeli Terverifikasi' : 'Supplier Terverifikasi',
            onTap: isSupplier
                ? null
                : () => context.push(
                      '/supplier/${o.seller.id}',
                      extra: {'name': o.seller.name},
                    ),
          ),
          SizedBox(height: 12.h),
          _buildSection('Informasi Dasar', [
            _infoRow('No. Pesanan', o.displayOrderNumber),
            if (_batchOrderIds.length > 1)
              _infoRow('No. internal toko', o.orderNumber),
            _infoRow(
              'Tanggal Pesan',
              DateFormat('dd MMM yyyy, HH:mm').format(o.createdAt),
            ),
          ]),
          SizedBox(height: 12.h),
          _buildShippingSection(o),
          if (o.status == 'PENDING') ...[
            SizedBox(height: 12.h),
            _buildAwaitingPaymentBanner(o),
          ],
          if (o.status != 'PENDING' &&
              o.shipment != null &&
              o.shipment?.vesselName != null &&
              o.shipment!.vesselName != 'Menunggu pembayaran') ...[
            SizedBox(height: 12.h),
            _buildSection('Status Pengiriman', [
              _infoRow('Kapal/Kendaraan', o.shipment!.vesselName!),
              if (o.shipment?.originHub != null)
                _infoRow('Hub Asal', o.shipment!.originHub!),
              if (o.shipment?.destinationHub != null)
                _infoRow('Hub Tujuan', o.shipment!.destinationHub!),
              if (o.shipment?.currentLat != null && o.shipment?.currentLng != null) ...[
                SizedBox(height: 10.h),
                OrderTrackingMap(
                  lat: (o.shipment!.currentLat as num).toDouble(),
                  lng: (o.shipment!.currentLng as num).toDouble(),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () => url_launcher.launchUrl(
                    Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${o.shipment!.currentLat},${o.shipment!.currentLng}',
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.mapPin, color: AppColors.primary, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Buka di Google Maps',
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
          SizedBox(height: 12.h),
          _buildSection('Item Pesanan', [
            ...o.items.map((item) => _itemRow(item, currencyFormatter)),
          ]),
          if (o.specifications != null && o.specifications!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildSection('Spesifikasi Kesepakatan', [
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
          SizedBox(height: 12.h),
          _buildSection('Rincian Pembayaran', [
            _priceRow('Subtotal Produk', o.subtotal, currencyFormatter),
            _priceRow('Biaya Layanan', o.platformFee, currencyFormatter),
            if (o.logisticsFee > 0)
              _priceRow('Biaya Ongkir', o.logisticsFee, currencyFormatter),
            _priceRow('PPN (VAT)', o.vatAmount, currencyFormatter),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: const Divider(color: AppColors.grey100),
            ),
            _priceRow(
              'Total Pembayaran',
              o.totalAmount,
              currencyFormatter,
              isBold: true,
            ),
          ]),
          SizedBox(height: 12.h),
          _buildPaymentStatusSection(o),
          if (o.status == 'PENDING') ...[
            SizedBox(height: 12.h),
            _buildPaymentMethodSection(context, o),
          ],
          SizedBox(height: 24.h),
          _buildActions(context),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 24.h),
        ],
      ),
    );
  }

  Widget _buildAwaitingPaymentBanner(OrderEntity o) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.clock, size: 18.sp, color: AppColors.warning),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menunggu pembayaran',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Pesanan #${o.orderNumber} sudah dibuat. Pilih metode pembayaran lalu lanjut ke instruksi bayar.',
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

  Widget _buildPaymentMethodSection(BuildContext context, OrderEntity o) {
    final channelCode = _resolvedChannelCode(o);
    final channelName = _resolvedChannelName(o);
    final hasSelection = channelCode != null && channelCode.isNotEmpty;
    final selectedDiffersFromInitialized = _pendingPayment != null &&
        _pendingPayment!['channelCode']?.toString().toUpperCase() !=
            channelCode?.toUpperCase();

    return _buildSection('Metode Pembayaran', [
      if (hasSelection) ...[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.wallet, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode dipilih',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      channelName ?? 'Pembayaran',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _pickPaymentMethod(context, o),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Ubah',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (selectedDiffersFromInitialized) ...[
          SizedBox(height: 8.h),
          Text(
            'Metode baru dipilih. Tekan "Lanjut ke Pembayaran" untuk memperbarui VA/QR.',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.warning,
              height: 1.4,
            ),
          ),
        ],
      ] else ...[
        OutlinedButton.icon(
          onPressed: () => _pickPaymentMethod(context, o),
          icon: Icon(LucideIcons.wallet, size: 16.sp),
          label: Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
            minimumSize: Size(double.infinity, 44.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Pilih metode terlebih dahulu untuk mengaktifkan tombol lanjut bayar.',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textHint,
            height: 1.4,
          ),
        ),
      ],
    ]);
  }

  String _paymentStatusLabel(OrderEntity o) {
    final tx = o.transaction;
    if (tx == null) return 'Belum diinisialisasi';
    switch (tx.paymentStatus?.toUpperCase()) {
      case 'SUCCESS':
        return 'Lunas';
      case 'PENDING':
        return 'Menunggu Pembayaran';
      case 'FAILED':
        return 'Gagal';
      case 'EXPIRED':
        return 'Kedaluwarsa';
      case 'REFUNDED':
        return 'Dikembalikan';
      default:
        return tx.paymentStatus ?? '-';
    }
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
    final tx = o.transaction;
    if (tx == null) return '-';
    switch (tx.status.toUpperCase()) {
      case 'ESCROW_HELD':
        return 'Dana ditahan (escrow)';
      case 'RELEASED':
        return 'Dana dilepas ke penjual';
      case 'PENDING':
        return 'Menunggu pembayaran';
      case 'REFUNDED':
        return 'Dana dikembalikan';
      default:
        return tx.status;
    }
  }

  Widget _buildPaymentStatusSection(OrderEntity o) {
    final tx = o.transaction;
    final paymentLabel = _paymentStatusLabel(o);
    final paymentColor = _paymentStatusColor(o);
    final channelName = _resolvedChannelName(o);
    final paidAt = tx?.paidAt;

    final isPaymentExpired =
        tx?.paymentStatus?.toUpperCase() == 'EXPIRED';

    return _buildSection('Status Pembayaran', [
      if (tx?.paymentStatus?.toUpperCase() == 'PENDING' ||
          isPaymentExpired) ...[
        PaymentExpiryBanner(
          pendingPayment: _pendingPayment ?? o.pendingPayment,
          orderCreatedAt: o.createdAt,
          paymentStatus: tx?.paymentStatus,
        ),
        SizedBox(height: 10.h),
      ],
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: paymentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: paymentColor.withValues(alpha: 0.25)),
        ),
        child: Row(
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
            SizedBox(width: 10.w),
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
                      'Escrow: ${_escrowStatusLabel(o)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      if (channelName != null && channelName.isNotEmpty)
        _infoRow('Metode', channelName),
      if (paidAt != null)
        _infoRow(
          'Dibayar pada',
          DateFormat('dd MMM yyyy, HH:mm').format(paidAt),
        ),
      if (tx == null)
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            'Pembayaran belum diinisialisasi. Pilih metode lalu lanjut bayar.',
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

    return Column(
      children: [
        if (o.status != 'CANCELLED')
          _actionButton(
            'Unduh Invoice (PDF)',
            AppColors.primary,
            () => InvoiceExportHelper.exportOrder(context, o),
            isOutlined: true,
          ),
        if (isBuyer && o.status == 'PENDING') ...[
          _actionButton(
            'Lanjut ke Pembayaran',
            AppColors.primary,
            _hasPaymentMethodSelected(o) && !_paymentBusy
                ? () => _continueToPayment(context, o)
                : null,
            useGradient: true,
          ),
        ],
        if (isBuyer &&
            (o.status == 'SHIPPED' || o.status == 'PROCESSING')) ...[
          if (o.status == 'SHIPPED')
            _actionButton(
              'Pesanan Diterima',
              AppColors.secondary,
              () => _confirmReleaseEscrow(context),
              useGradient: true,
            ),
          _actionButton(
            'Ajukan Sengketa',
            AppColors.error,
            () => _showDisputeDialog(context),
            isOutlined: true,
          ),
        ],
        // Buyer Actions (Completed Order)
        if (isBuyer && o.status == 'COMPLETED') ...[
          if (o.review == null)
            _actionButton('Tulis Ulasan', AppColors.primary, () async {
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
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20.r),
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
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
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
                                  'Ulasan Terverifikasi',
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
                          'Ubah',
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
                  SizedBox(height: 12.h),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        LucideIcons.star,
                        color: index < o.review!.rating
                            ? Colors.amber
                            : AppColors.grey200,
                        size: 18.sp,
                        fill: index < o.review!.rating ? 1 : 0,
                      );
                    }),
                  ),
                  SizedBox(height: 12.h),
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
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              _showFullReview
                                  ? 'Sembunyikan'
                                  : 'Lihat Selengkapnya',
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
        ],
        if (isSupplier && (o.status == 'PROCESSING' || o.status == 'SHIPPED'))
          _actionButton(
            'Update Pengiriman',
            AppColors.primary,
            () => _showUpdateTrackingDialog(context, o),
          ),
        if (o.status.toUpperCase() == 'DISPUTED') ...[
          _actionButton(
            'Refresh Status Sengketa',
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
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Tanggapan Sengketa',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Jelaskan posisi Anda dan lampirkan bukti jika ada.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      CustomTextField(
                        label: 'Tanggapan',
                        hint: 'Min. 10 karakter',
                        controller: responseController,
                        maxLines: 4,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Foto Bukti (opsional, max 5)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...evidencePaths.map(
                            (path) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
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
                                        color: Colors.white,
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
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: const Icon(
                                  LucideIcons.camera,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: 'kirim'.tr(),
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
                      SizedBox(height: 8.h),
                      CustomButton(
                        text: 'batal'.tr(),
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomButton(
        text: title,
        onPressed: onTap,
        isOutlined: isOutlined,
        useGradient: useGradient,
        backgroundColor: isOutlined ? color : color,
      ),
    );
  }

  void _confirmReleaseEscrow(BuildContext context) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'konfirmasi'.tr(),
      message:
          'Apakah Anda yakin pesanan sudah diterima dengan baik? Dana akan diteruskan ke penjual.',
      confirmText: 'ya_terima'.tr(),
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
                const Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    failure.message,
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
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'ajukan_sengketa'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      CustomTextField(
                        label: 'Alasan',
                        hint: 'Min. 10 karakter',
                        controller: reasonController,
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        label: 'Deskripsi Masalah',
                        hint: 'Jelaskan masalah',
                        controller: descController,
                        maxLines: 3,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Foto Bukti (opsional, max 5)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...evidencePaths.map(
                            (path) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
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
                                        color: Colors.white,
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
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: const Icon(
                                  LucideIcons.camera,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: 'kirim'.tr(),
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
                      SizedBox(height: 8.h),
                      CustomButton(
                        text: 'batal'.tr(),
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
      text: shipment?.vesselName ?? 'Pengiriman BISA',
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
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'update_pengiriman'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (shipment?.trackingNumber?.isNotEmpty ?? false) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Tracking BISA: ${shipment!.trackingNumber}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                ],
                SizedBox(height: 14.h),
                CustomTextField(
                  label: 'Nama armada / ekspedisi',
                  hint: 'Contoh: JNE Reguler',
                  controller: vesselController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: 'Nomor resi kurir (AWB)',
                  hint: 'Minimal 5 karakter',
                  controller: awbController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: 'Kode kurir',
                  hint: 'jne, jnt, sicepat, ...',
                  controller: courierController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: 'Asal hub',
                  hint: 'Opsional',
                  controller: originController,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  label: 'Tujuan hub',
                  hint: 'Opsional',
                  controller: destController,
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  text: 'update'.tr(),
                  height: 46.h,
                  onPressed: () async {
                    final vessel = vesselController.text.trim();
                    if (vessel.length < 3) {
                      showBisaSnackBar(
                        context,
                        content: const Text('Nama armada minimal 3 karakter.'),
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
                SizedBox(height: 8.h),
                CustomButton(
                  text: 'batal'.tr(),
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
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => context.push('/order-batch/${o.id}'),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Icon(LucideIcons.layers, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Bagian checkout ${_batchOrderIds.length} toko — lihat semua produk & status',
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: AppColors.textOnPrimary, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'order_status'.tr(),
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
    switch (o.status.toUpperCase()) {
      case 'DISPUTED':
        return o.dispute?.statusLabel ?? 'Sengketa';
      case 'PENDING':
        return 'Menunggu Pembayaran';
      case 'PROCESSING':
        return 'Diproses';
      case 'SHIPPED':
        return 'Dikirim';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return o.status.toUpperCase();
    }
  }


  Widget _buildParticipantCard({
    required OrderParticipantEntity participant,
    required String sectionLabel,
    required String verifiedLabel,
    VoidCallback? onTap,
  }) {
    final content = Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
          SizedBox(width: 12.w),
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
        rows.add(_infoRow('Penerima', recipient));
      }
      if (phone != null && phone.isNotEmpty) {
        rows.add(_infoRow('Telepon', phone));
      }
      if (email != null && email.isNotEmpty) {
        rows.add(_infoRow('Email', email));
      }
      if (address != null && address.isNotEmpty) {
        rows.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Lengkap',
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
        rows.add(_infoRow('Wilayah', locationParts.join(', ')));
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
          rows.add(_infoRow('Kurir', courier.toUpperCase()));
        }
        if (service != null && service.isNotEmpty) {
          rows.add(_infoRow('Layanan', service));
        }
        if (destinationLabel != null && destinationLabel.isNotEmpty) {
          rows.add(_infoRow('Tujuan Ongkir', destinationLabel));
        }
        if (etd != null && etd.isNotEmpty) {
          rows.add(_infoRow('Estimasi', etd));
        }
        if (costRaw != null) {
          final cost = double.tryParse(costRaw.toString());
          if (cost != null) {
            final formattedCost = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(cost);
            rows.add(_infoRow('Biaya Ongkir', formattedCost));
          }
        }
      }
    }

    final orderShipping = o.orderShipping;
    if (orderShipping != null) {
      if (orderShipping.courierCode != null &&
          orderShipping.courierCode!.isNotEmpty) {
        rows.add(_infoRow('Kurir', orderShipping.courierCode!.toUpperCase()));
      }
      if (orderShipping.serviceName != null && orderShipping.serviceName!.isNotEmpty) {
        rows.add(_infoRow('Layanan', orderShipping.serviceName!));
      }
      if (orderShipping.destinationLabel != null &&
          orderShipping.destinationLabel!.isNotEmpty) {
        rows.add(_infoRow('Tujuan', orderShipping.destinationLabel!));
      }
      if (orderShipping.shippingCost != null) {
        final formattedCost = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(orderShipping.shippingCost);
        rows.add(_infoRow('Biaya Ongkir', formattedCost));
      }
      if (orderShipping.etd != null && orderShipping.etd!.isNotEmpty) {
        rows.add(_infoRow('ETD', orderShipping.etd!));
      }
    }

    final shipment = o.shipment;
    if (shipment != null) {
      final tracking = shipment.trackingNumber?.trim();
      if (tracking != null && tracking.isNotEmpty) {
        rows.add(_infoRow('No. Tracking BISA', tracking));
      }
      if (shipment.awbNumber != null && shipment.awbNumber!.isNotEmpty) {
        rows.add(_infoRow('No. Resi Kurir', shipment.awbNumber!));
      }
      if (shipment.courierCode != null && shipment.courierCode!.isNotEmpty) {
        rows.add(_infoRow('Kurir', shipment.courierCode!.toUpperCase()));
      }
      if (shipment.deliveryStatus != null && shipment.deliveryStatus!.isNotEmpty) {
        rows.add(_infoRow('Status Kirim', shipment.deliveryStatus!));
      }
      if (shipment.lastTrackedAt != null) {
        rows.add(
          _infoRow(
            'Terakhir Sinkron',
            DateFormat('dd MMM yyyy, HH:mm').format(shipment.lastTrackedAt!),
          ),
        );
      }
      if (shipment.awbNumber != null &&
          shipment.awbNumber!.isNotEmpty &&
          shipment.courierCode != null &&
          shipment.courierCode!.isNotEmpty) {
        rows.add(
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: OutlinedButton.icon(
              onPressed: _trackingSyncBusy ? null : () => _syncTrackingFromRajaOngkir(o),
              icon: _trackingSyncBusy
                  ? SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(LucideIcons.refreshCcw, size: 15.sp),
              label: Text(
                _trackingSyncBusy ? 'Sinkronisasi...' : 'Sync Tracking RajaOngkir',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                minimumSize: Size(double.infinity, 42.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        );
      }
    }

    if (rows.isEmpty) {
      rows.add(
        Text(
          'Alamat pengiriman belum tersedia untuk pesanan ini.',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      );
    }

    return _buildSection('Alamat Pengiriman', rows);
  }

  Future<void> _syncTrackingFromRajaOngkir(OrderEntity order) async {
    final shipment = order.shipment;
    final awb = shipment?.awbNumber;
    final courier = shipment?.courierCode;
    if (awb == null || awb.isEmpty || courier == null || courier.isEmpty) {
      showBisaSnackBar(
        context,
        content: const Text(
          'Nomor resi / kurir belum tersedia untuk sinkronisasi.',
        ),
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
          content: const Text('Gagal sinkron tracking dari RajaOngkir.'),
          backgroundColor: AppColors.error,
        );
        return;
      }
      await _reloadOrderDetail(silent: true);
      if (!mounted) return;
      showBisaSnackBar(
        context,
        content: const Text('Tracking berhasil disinkronkan.'),
        backgroundColor: AppColors.success,
      );
    } finally {
      if (mounted) {
        setState(() => _trackingSyncBusy = false);
      }
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
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
          SizedBox(width: 12.w),
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
      padding: EdgeInsets.only(bottom: 12.h),
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
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.grey100),
              ),
              child: item.thumbnailUrl != null &&
                      item.thumbnailUrl!.trim().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
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
          SizedBox(width: 12.w),
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
          SizedBox(width: 8.w),
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
      padding: EdgeInsets.only(bottom: 8.h),
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
