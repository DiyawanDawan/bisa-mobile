import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:mobile_bisa/core/config/app_config.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/orders/domain/repositories/order_repository.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/checkout_navigation.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/payment_proof_ocr_util.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/payment_result_utils.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_expiry_banner.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_method_picker_sheet.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';

/// Halaman instruksi pembayaran (Payment Request V3 → DIRECT mode).
class PaymentInstructionPage extends StatefulWidget {
  final String orderId;
  final String orderNumber;
  final num amount;
  final Map<String, dynamic> paymentResult;
  final List<String> batchOrderIds;
  final DateTime? orderCreatedAt;
  final String? paymentStatus;

  const PaymentInstructionPage({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.amount,
    required this.paymentResult,
    this.batchOrderIds = const [],
    this.orderCreatedAt,
    this.paymentStatus,
  });

  @override
  State<PaymentInstructionPage> createState() => _PaymentInstructionPageState();
}

class _PaymentInstructionPageState extends State<PaymentInstructionPage> {
  late Map<String, dynamic> _paymentResult;
  bool _busy = false;
  bool _paymentConfirmed = false;
  /// Cegah tap "bocor" ke tombol kembali saat layout footer berubah setelah simulasi.
  bool _blockExitTap = false;

  // — State bukti transfer manual —
  File? _proofFile;
  bool _ocrScanning = false;
  bool _proofUploading = false;
  PaymentProofOcrResult? _ocrResult;
  bool _proofSubmitted = false;

  bool get _hasPayableInstructionData =>
      paymentInstructionsReady(_paymentResult);

  @override
  void initState() {
    super.initState();
    _paymentResult = Map<String, dynamic>.from(widget.paymentResult);
    if (!_hasPayableInstructionData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _regeneratePaymentInstructions();
      });
    }
  }

  String get _paymentType =>
      (_paymentResult['paymentType'] as String?)?.toUpperCase() ?? 'UNKNOWN';
  String get _channelCode =>
      (_paymentResult['channelCode'] as String?)?.toUpperCase() ?? '';

  bool get _isMockPayment => _paymentResult['isMockPayment'] == true;

  /// Debug, APK development (`APP_ENV!=production`), atau mock payment.
  bool get _showSimulateButton =>
      kDebugMode || AppConfig.isDevelopment || _isMockPayment;

  bool get _hasRealPaymentRequest {
    final id = _paymentResult['paymentRequestId']?.toString() ?? '';
    return id.isNotEmpty && !id.startsWith('mock-');
  }

  Map<String, dynamic> get _data {
    final raw = _paymentResult['paymentData'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  String? get _vaNumber {
    final d = _data;
    return (d['virtual_account_number'] ??
            d['virtualAccountNumber'] ??
            d['account_number'] ??
            d['accountNumber'] ??
            d['payment_code'] ??
            d['paymentCode'])
        ?.toString();
  }

  String? get _qrString {
    final d = _data;
    return _paymentResult['paymentData']?['qrString'] ??
        d['qr_string'] ??
        d['qrString'] ??
        d['qr_code']
            ?.toString();
  }

  String? get _redirectUrl {
    final d = _data;
    return (d['redirectUrl'] ?? d['redirect_url'])?.toString();
  }

  String get _channelLabel {
    final code = _channelCode;
    switch (_paymentType) {
      case 'VIRTUAL_ACCOUNT':
        return 'orders.payment_channel_va'.tr(namedArgs: {'code': code});
      case 'EWALLET':
        return 'orders.payment_channel_ewallet'.tr(namedArgs: {'code': code});
      case 'QR_CODE':
        return 'orders.payment_channel_qris'.tr();
      case 'OVER_THE_COUNTER':
        return 'orders.payment_channel_otc'.tr(namedArgs: {'code': code});
      case 'CREDIT_CARD':
        return 'orders.payment_channel_credit_card'.tr();
      default:
        return code.isEmpty
            ? 'orders.payment_fallback'.tr()
            : code;
    }
  }

  IconData get _channelIcon {
    switch (_paymentType) {
      case 'EWALLET':
        return LucideIcons.wallet;
      case 'QR_CODE':
        return LucideIcons.qrCode;
      case 'VIRTUAL_ACCOUNT':
        return LucideIcons.landmark;
      case 'OVER_THE_COUNTER':
        return LucideIcons.store;
      case 'CREDIT_CARD':
        return LucideIcons.creditCard;
      default:
        return LucideIcons.creditCard;
    }
  }

  /// Batch = checkout multi-supplier (2+ orderId dengan checkoutBatchId sama).
  bool get _isBatchPayment => widget.batchOrderIds.length > 1;

  List<String> get _orderNumbers {
    final batchNo = _paymentResult['checkoutBatchNumber']?.toString().trim();
    if (batchNo != null && batchNo.isNotEmpty) return [batchNo];

    final raw = _paymentResult['orderNumbers'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    final single = widget.orderNumber.trim();
    if (single.isEmpty) return const [];
    if (single.contains('pesanan checkout')) return const [];
    return [single];
  }

  void _showPaymentSnack(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (!mounted) return;
    showBisaSnackBar(
      context,
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      extraBottom: paymentInstructionFooterClearance,
    );
  }

  Future<void> _copyText(String value, {String? label}) async {
    await Clipboard.setData(ClipboardData(text: value));
    final copyLabel = label ?? 'orders.copy_default_label'.tr();
    _showPaymentSnack(
      'orders.copy_snackbar'.tr(namedArgs: {'label': copyLabel}),
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _regeneratePaymentInstructions() async {
    if (_channelCode.isEmpty) return;
    setState(() => _busy = true);
    final result = _isBatchPayment
        ? await sl<OrderRepository>().initializeBatchPayment(
            widget.batchOrderIds,
            _channelCode,
            forceNew: true,
          )
        : await sl<OrderRepository>().initializePayment(
            widget.orderId,
            _channelCode,
            forceNew: true,
          );
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _busy = false);
        _showPaymentSnack(failure.message.localizedFailure, backgroundColor: AppColors.error);
      },
      (data) {
        setState(() {
          _paymentResult = Map<String, dynamic>.from(data);
          _busy = false;
        });
        if (!paymentInstructionsReady(_paymentResult) && mounted) {
          _showPaymentSnack(
            'orders.va_qr_unavailable'.tr(),
            backgroundColor: AppColors.warning,
          );
        }
      },
    );
  }

  Future<void> _changePaymentMethod() async {
    final choice = await PaymentMethodPickerSheet.show(
      context,
      amount: widget.amount,
      initialCode: _paymentResult['channelCode']?.toString(),
    );
    if (choice == null || !mounted) return;

    setState(() => _busy = true);
    final result = _isBatchPayment
        ? await sl<OrderRepository>().initializeBatchPayment(
            widget.batchOrderIds,
            choice.code,
            forceNew: true,
          )
        : await sl<OrderRepository>().initializePayment(
            widget.orderId,
            choice.code,
            forceNew: true,
          );
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _busy = false);
        _showPaymentSnack(failure.message.localizedFailure, backgroundColor: AppColors.error);
      },
      (data) {
        setState(() {
          _paymentResult = Map<String, dynamic>.from(data);
          _busy = false;
        });
        _showPaymentSnack(
          'orders.method_changed_to'.tr(namedArgs: {'method': _channelLabel}),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  Future<void> _simulatePayment() async {
    setState(() => _busy = true);
    final result = _isBatchPayment
        ? await sl<OrderRepository>().simulateBatchPayment(widget.batchOrderIds)
        : await sl<OrderRepository>().simulatePayment(widget.orderId);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _busy = false);
        _showPaymentSnack(failure.message.localizedFailure, backgroundColor: AppColors.error);
      },
      (_) {
        setState(() {
          _busy = false;
          _paymentConfirmed = true;
          _blockExitTap = true;
        });
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _blockExitTap = false);
        });
        _showPaymentSnack(
          'orders.payment_simulated'.tr(),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        );
      },
    );
  }

  Future<void> _pollPaymentFromServer() async {
    final paid = await pollOrderPaymentStatus(
      sl<OrderRepository>(),
      widget.orderId,
    );
    if (!mounted) return;
    if (paid) {
      setState(() {
        _paymentConfirmed = true;
        _blockExitTap = true;
      });
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _blockExitTap = false);
      });
      _showPaymentSnack(
        'orders.payment_confirmed_server'.tr(),
        backgroundColor: AppColors.success,
      );
    } else {
      _showPaymentSnack(
        'orders.payment_not_confirmed_yet'.tr(),
        backgroundColor: AppColors.warning,
      );
    }
  }

  Future<void> _cancelPayment() async {
    setState(() => _busy = true);
    final result = await sl<OrderRepository>().cancelPayment(widget.orderId);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _busy = false);
        _showPaymentSnack(failure.message.localizedFailure, backgroundColor: AppColors.error);
      },
      (_) {
        if (mounted) context.pop(false);
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    _showPaymentSnack(message, backgroundColor: AppColors.error);
  }

  Future<void> _handleLeavePage() async {
    if (_busy || _blockExitTap) return;

    if (!_paymentConfirmed) {
      final leave = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('orders.leave_dialog_title'.tr()),
          content: Text('orders.leave_dialog_body'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('orders.leave_stay'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('orders.leave_back'.tr()),
            ),
          ],
        ),
      );
      if (leave != true || !mounted) return;
      leavePaymentInstruction(
        context,
        paymentConfirmed: false,
        batchOrderIds: widget.batchOrderIds,
      );
      return;
    }

    leavePaymentInstruction(
      context,
      paymentConfirmed: _paymentConfirmed,
      batchOrderIds: widget.batchOrderIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _handleLeavePage();
        });
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'orders.payment_instruction_title'.tr(),
        backgroundColor: AppColors.surface,
        onBackTap: _handleLeavePage,
      ),
      body: Column(
        children: [
          if (_busy)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.primary,
              backgroundColor: AppColors.grey100,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_paymentConfirmed) ...[
                    PaymentExpiryBanner(
                      pendingPayment: _paymentResult,
                      orderCreatedAt: widget.orderCreatedAt,
                      paymentStatus: widget.paymentStatus,
                    ),
                    SizedBox(height: AppSpacing.md12),
                  ],
                  if (_paymentConfirmed) ...[
                    _successBanner(),
                    SizedBox(height: AppSpacing.md12),
                  ] else if (!_hasPayableInstructionData && !_busy) ...[
                    _missingPaymentDataBanner(),
                    SizedBox(height: AppSpacing.md12),
                  ],
                  _summaryCard(),
                  if (_orderNumbers.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md12),
                    _orderNumbersCard(),
                  ],
                  SizedBox(height: AppSpacing.md12),
                  _selectedMethodBanner(),
                  SizedBox(height: AppSpacing.section),
                  _instructionCard(context),
                  SizedBox(height: AppSpacing.section),
                  _stepsCard(),
                  if (!_paymentConfirmed) ...[
                    SizedBox(height: AppSpacing.section),
                    _paymentProofCard(),
                  ],
                  if (!_paymentConfirmed &&
                      (_isMockPayment ||
                          (_showSimulateButton && _hasRealPaymentRequest))) ...[
                    SizedBox(height: AppSpacing.md12),
                    _mockBanner(),
                  ],
                ],
              ),
            ),
          ),
          _bottomActions(context),
        ],
      ),
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.grey200)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_paymentConfirmed && !_hasPayableInstructionData) ...[
            CustomButton(
              text: 'orders.action_generate_va'.tr(),
              backgroundColor: AppColors.primary,
              onPressed: _busy ? null : _regeneratePaymentInstructions,
            ),
            SizedBox(height: AppSpacing.sm),
          ],
          // Simulasi tetap ada (debug / APP_ENV development / mock)
          if (_showSimulateButton && !_paymentConfirmed) ...[
            CustomButton(
              text: 'orders.action_simulate_payment'.tr(),
              backgroundColor: AppColors.warning,
              onPressed: _busy ? null : _simulatePayment,
            ),
            SizedBox(height: AppSpacing.sm),
          ],
          // Satu baris: Ganti metode + Kembali
          if (!_paymentConfirmed)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'orders.action_change_method_short'.tr(),
                    isOutlined: true,
                    onPressed: _busy ? null : _changePaymentMethod,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: CustomButton(
                    text: 'orders.action_back'.tr(),
                    useGradient: true,
                    onPressed:
                        (_busy || _blockExitTap) ? null : _handleLeavePage,
                  ),
                ),
              ],
            )
          else
            CustomButton(
              text: _isBatchPayment
                  ? 'orders.action_back_to_orders'.tr()
                  : 'orders.action_back_to_detail'.tr(),
              useGradient: true,
              onPressed: (_busy || _blockExitTap) ? null : _handleLeavePage,
            ),
          if (!_paymentConfirmed)
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _busy ? null : _cancelPayment,
              child: Text(
                'orders.action_cancel_payment'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _missingPaymentDataBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.triangleAlert, size: 22.sp, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.va_qr_missing_title'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.warning,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'orders.va_qr_missing_body'.tr(),
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

  Widget _successBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, size: 22.sp, color: AppColors.success),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.payment_success_title'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'orders.payment_success_body'.tr(),
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

  Widget _mockBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.flaskConical, size: 18.sp, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'orders.simulate_mode_banner'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders.field_total_payment'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textOnPrimary.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Rp ${_formatAmount(widget.amount)}',
            style: TextStyle(
              fontSize: 24.sp,
              color: AppColors.surface,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Text(
              _channelCode.isEmpty
                  ? 'orders.payment_badge_fallback'.tr()
                  : _channelCode,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.surface,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderNumbersCard() {
    final numbers = _orderNumbers;
    final isBatch = numbers.length > 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.receiptText, size: 16.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Text(
                isBatch
                    ? 'orders.field_order_number_batch'.tr(
                        namedArgs: {'count': '${numbers.length}'},
                      )
                    : 'orders.field_order_number'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          ...numbers.map((no) => Padding(
                padding: EdgeInsets.only(bottom: numbers.last == no ? 0 : 8.h),
                child: _orderNumberRow(no),
              )),
        ],
      ),
    );
  }

  Widget _orderNumberRow(String orderNumber) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              orderNumber,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ),
          InkWell(
            onTap: () => _copyText(orderNumber),
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Icon(
                LucideIcons.copy,
                size: 16.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedMethodBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(_channelIcon, color: AppColors.textOnPrimary, size: 20.sp),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.method_selected_label'.tr(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _channelLabel,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.circleCheck, color: AppColors.primary, size: 22.sp),
        ],
      ),
    );
  }

  Widget _instructionCard(BuildContext context) {
    final type = _paymentType;
    if (type == 'QR_CODE' || _qrString != null) {
      return _qrCard(_qrString ?? '');
    }
    if (type == 'EWALLET' || (_redirectUrl != null && _vaNumber == null)) {
      return _ewalletCard(context);
    }
    if (type == 'OVER_THE_COUNTER') {
      return _vaCard(
        label: 'orders.field_payment_code'.tr(),
        value: _vaNumber ?? '-',
      );
    }
    return _vaCard(
      label: 'orders.field_va_number'.tr(),
      value: _vaNumber ?? '-',
    );
  }

  Widget _vaCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.landmark, color: AppColors.primary, size: 18.sp),
              SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Builder(
                  builder: (ctx) {
                    return InkWell(
                      onTap: value == '-'
                          ? null
                          : () async {
                              await Clipboard.setData(ClipboardData(text: value));
                              if (ctx.mounted) {
                                showBisaSnackBar(
                                  ctx,
                                  content: Text(
                                    'orders.copy_snackbar'.tr(
                                      namedArgs: {'label': label},
                                    ),
                                  ),
                                  backgroundColor: AppColors.success,
                                  duration: const Duration(seconds: 2),
                                  extraBottom: paymentInstructionFooterClearance,
                                );
                              }
                            },
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: Icon(
                          LucideIcons.copy,
                          color: value == '-' ? AppColors.grey300 : AppColors.primary,
                          size: 18.sp,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (value == '-') ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              'orders.va_unavailable_hint'.tr(),
              style: TextStyle(fontSize: 11.sp, color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _qrCard(String qrData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.qrCode, color: AppColors.primary, size: 18.sp),
              SizedBox(width: AppSpacing.sm),
              Text(
                'orders.qr_scan_hint'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (qrData.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h),
              child: Text(
                'orders.qr_unavailable_hint'.tr(),
                style: TextStyle(fontSize: 12.sp, color: AppColors.error),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: QrImageView(
                data: qrData,
                size: 220.w,
                backgroundColor: AppColors.surface,
              ),
            ),
          SizedBox(height: AppSpacing.md12),
          Text(
            'orders.qr_amount_hint'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _ewalletCard(BuildContext context) {
    final url = _redirectUrl;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.wallet, color: AppColors.primary, size: 18.sp),
              SizedBox(width: AppSpacing.sm),
              Text(
                'orders.ewallet_pay_via'.tr(namedArgs: {'channel': _channelCode}),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Text(
            url == null
                ? 'orders.ewallet_link_unavailable'.tr()
                : 'orders.ewallet_open_app_hint'.tr(
                    namedArgs: {'channel': _channelCode},
                  ),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          SizedBox(height: AppSpacing.section),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: url == null
                  ? null
                  : () async {
                      final uri = Uri.tryParse(url);
                      if (uri == null) return;
                      try {
                        final ok = await url_launcher.launchUrl(
                          uri,
                          mode: url_launcher.LaunchMode.externalApplication,
                        );
                        if (!ok && context.mounted) {
                          final webResult = await context.push(
                            '/payment-webview',
                            extra: {
                              'url': url,
                              'title': 'orders.payment_webview_channel_title'
                                  .tr(namedArgs: {'channel': _channelCode}),
                            },
                          );
                          if (!context.mounted) return;
                          final exit = parsePaymentWebViewExit(webResult);
                          if (exit != PaymentWebViewExit.failed) {
                            await _pollPaymentFromServer();
                          }
                        }
                      } catch (_) {
                        _showError('orders.ewallet_open_failed'.tr());
                      }
                    },
              icon: Icon(LucideIcons.externalLink, size: 18.sp),
              label: Text('orders.ewallet_open_button'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                disabledBackgroundColor: AppColors.grey200,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepsCard() {
    final type = _paymentType;
    final steps = type == 'QR_CODE'
        ? [
            'orders.step_qr_1'.tr(),
            'orders.step_qr_2'.tr(),
            'orders.step_qr_3'.tr(),
            'orders.step_qr_4'.tr(),
          ]
        : type == 'EWALLET'
            ? [
                'orders.step_ewallet_1'.tr(),
                'orders.step_ewallet_2'.tr(),
                'orders.step_ewallet_3'.tr(),
                'orders.step_ewallet_4'.tr(),
              ]
            : type == 'OVER_THE_COUNTER'
                ? [
                    'orders.step_otc_1'.tr(),
                    'orders.step_otc_2'.tr(),
                    'orders.step_otc_3'.tr(),
                    'orders.step_otc_4'.tr(),
                  ]
                : [
                    'orders.step_va_1'.tr(),
                    'orders.step_va_2'.tr(),
                    'orders.step_va_3'.tr(),
                    'orders.step_va_4'.tr(),
                    'orders.step_va_5'.tr(),
                  ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.listOrdered, color: AppColors.primary, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                'orders.how_to_pay_title'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          ...List.generate(steps.length, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.w,
                    height: 22.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatAmount(num n) {
    final s = n.toStringAsFixed(0);
    final reversed = s.split('').reversed.toList();
    final chunks = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      chunks.add(reversed.skip(i).take(3).join());
    }
    return chunks.join('.').split('').reversed.join();
  }

  // ─── Bukti Transfer Manual ──────────────────────────────────────────────────

  /// Pilih gambar bukti transfer dari galeri atau kamera, lalu jalankan OCR.
  Future<void> _pickAndScanProof(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 88);
    if (picked == null || !mounted) return;

    final file = File(picked.path);
    setState(() {
      _proofFile = file;
      _ocrScanning = true;
      _ocrResult = null;
      _proofSubmitted = false;
    });

    try {
      final result = await PaymentProofOcrUtil.processReceipt(
        picked.path,
        widget.amount.toDouble(),
      );
      if (mounted) setState(() => _ocrResult = result);
    } catch (_) {
      // OCR gagal — tetap izinkan upload manual
    } finally {
      if (mounted) setState(() => _ocrScanning = false);
    }
  }

  /// Upload gambar ke CDN lalu kirim URL ke backend.
  Future<void> _submitProof() async {
    if (_proofFile == null) return;
    setState(() => _proofUploading = true);
    try {
      // 1. Upload file ke CDN via MediaUploadQueue
      final queue = sl<MediaUploadQueue>();
      final uploaded = await queue.uploadFile(
        localPath: _proofFile!.path,
        folder: 'payment-proofs',
      );
      final uploadedUrl = uploaded.url!;

      // 2. Simpan URL ke backend
      final repo = sl<OrderRepository>();
      final result = await repo.uploadPaymentProof(widget.orderId, uploadedUrl);
      if (!mounted) return;

      result.fold(
        (failure) {
          _showPaymentSnack(
            failure.localizedMessage,
            backgroundColor: AppColors.error,
          );
        },
        (_) {
          setState(() {
            _proofSubmitted = true;
          });
          _showPaymentSnack('orders.proof_upload_success'.tr());
        },
      );
    } catch (e) {
      if (mounted) {
        _showPaymentSnack('orders.proof_upload_failed'.tr(), backgroundColor: AppColors.error);
      }
    } finally {
      if (mounted) setState(() => _proofUploading = false);
    }
  }

  /// Kartu upload bukti transfer manual dengan scan OCR on-device.
  Widget _paymentProofCard() {
    final bool hasFile = _proofFile != null;
    final bool hasMismatch =
        _ocrResult != null && !_ocrResult!.isAmountMatch && _ocrResult!.detectedAmount != null;
    final bool hasNoAmount =
        _ocrResult != null && _ocrResult!.detectedAmount == null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _proofSubmitted
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.grey200,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  LucideIcons.receipt,
                  color: AppColors.primary,
                  size: 18.r,
                ),
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'orders.proof_card_title'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'orders.proof_card_subtitle'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_proofSubmitted)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circleCheck, size: 12.r, color: AppColors.primaryMedium),
                      SizedBox(width: 4.w),
                      Text(
                        'orders.proof_sent'.tr(),
                        style: TextStyle(fontSize: 10.sp, color: AppColors.primaryMedium, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: AppSpacing.md12),

          // Preview gambar atau area pilih
          if (hasFile) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    _proofFile!,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                ),
                if (_ocrScanning)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 28.r, height: 28.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.surface,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'orders.proof_scanning'.tr(),
                            style: TextStyle(color: AppColors.surface, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Ganti foto
                if (!_ocrScanning && !_proofSubmitted)
                  Positioned(
                    top: 8.h, right: 8.w,
                    child: GestureDetector(
                      onTap: () => _pickAndScanProof(ImageSource.gallery),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(LucideIcons.refreshCcw, size: 14.r, color: AppColors.primary),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.sm10),

            // OCR Result chip
            if (!_ocrScanning && _ocrResult != null) ...[
              // Nominal match/mismatch
              if (_ocrResult!.isAmountMatch)
                _ocrChip(
                  icon: LucideIcons.circleCheck,
                  color: AppColors.primaryMedium,
                  bgColor: AppColors.primaryLight,
                  text: 'orders.proof_ocr_match'.tr(
                    namedArgs: {'amount': 'Rp ${_formatAmount(_ocrResult!.detectedAmount!)}'},
                  ),
                )
              else if (hasMismatch)
                _ocrChip(
                  icon: LucideIcons.triangleAlert,
                  color: AppColors.warning,
                  bgColor: AppColors.warning.withValues(alpha: 0.12),
                  text: 'orders.proof_ocr_mismatch'.tr(
                    namedArgs: {
                      'detected': 'Rp ${_formatAmount(_ocrResult!.detectedAmount!)}',
                      'expected': 'Rp ${_formatAmount(widget.amount)}',
                    },
                  ),
                )
              else if (hasNoAmount)
                _ocrChip(
                  icon: LucideIcons.scanLine,
                  color: AppColors.textSecondary,
                  bgColor: AppColors.grey100,
                  text: 'orders.proof_ocr_no_amount'.tr(),
                ),
              // Bank name
              if (_ocrResult!.detectedBank != null) ...[
                SizedBox(height: 6.h),
                _ocrChip(
                  icon: LucideIcons.landmark,
                  color: AppColors.primary,
                  bgColor: AppColors.primary.withValues(alpha: 0.08),
                  text: _ocrResult!.detectedBank!,
                ),
              ],
              SizedBox(height: AppSpacing.sm10),
            ],
          ] else ...[
            // Area pilih bukti — dua opsi: galeri & kamera
            Row(
              children: [
                Expanded(
                  child: _pickSourceButton(
                    icon: LucideIcons.image,
                    label: 'orders.proof_pick_gallery'.tr(),
                    onTap: () => _pickAndScanProof(ImageSource.gallery),
                  ),
                ),
                SizedBox(width: AppSpacing.sm10),
                Expanded(
                  child: _pickSourceButton(
                    icon: LucideIcons.camera,
                    label: 'orders.proof_pick_camera'.tr(),
                    onTap: () => _pickAndScanProof(ImageSource.camera),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm10),
          ],

          // Peringatan nominal tidak cocok
          if (hasMismatch && !_proofSubmitted) ...[
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.triangleAlert, size: 14.r, color: AppColors.warning),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'orders.proof_mismatch_warning'.tr(
                        namedArgs: {'expected': 'Rp ${_formatAmount(widget.amount)}'},
                      ),
                      style: TextStyle(fontSize: 11.sp, color: AppColors.warning, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm10),
          ],

          // Tombol kirim
          if (hasFile && !_proofSubmitted)
            CustomButton(
              text: _proofUploading
                  ? 'common.uploading'.tr()
                  : 'orders.proof_submit'.tr(),
              isLoading: _proofUploading,
              onPressed: _proofUploading ? null : _submitProof,
              backgroundColor: hasMismatch ? AppColors.warning : AppColors.primary,
            ),

          // Sudah terkirim — info
          if (_proofSubmitted)
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.circleCheck, size: 14.r, color: AppColors.primaryMedium),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'orders.proof_submitted_info'.tr(),
                      style: TextStyle(fontSize: 11.sp, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _ocrChip({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: color),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22.r, color: AppColors.primary),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
