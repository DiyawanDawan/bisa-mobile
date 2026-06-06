import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/orders/domain/repositories/order_repository.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/checkout_navigation.dart';
import 'package:mobile_bisa/features/orders/presentation/utils/payment_result_utils.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_expiry_banner.dart';
import 'package:mobile_bisa/features/orders/presentation/widgets/payment_method_picker_sheet.dart';
import 'package:mobile_bisa/injection_container.dart';
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

  bool get _showSimulateButton => kDebugMode;

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
        return '$code Virtual Account';
      case 'EWALLET':
        return '$code E-Wallet';
      case 'QR_CODE':
        return 'QRIS';
      case 'OVER_THE_COUNTER':
        return '$code Minimarket';
      case 'CREDIT_CARD':
        return 'Kartu Kredit';
      default:
        return code.isEmpty ? 'Pembayaran' : code;
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

  Future<void> _copyText(String value, {String label = 'Nomor pesanan'}) async {
    await Clipboard.setData(ClipboardData(text: value));
    _showPaymentSnack('$label disalin', duration: const Duration(seconds: 2));
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
        _showPaymentSnack(failure.message, backgroundColor: AppColors.error);
      },
      (data) {
        setState(() {
          _paymentResult = Map<String, dynamic>.from(data);
          _busy = false;
        });
        if (!paymentInstructionsReady(_paymentResult) && mounted) {
          _showPaymentSnack(
            'VA/QR masih belum tersedia. Coba ganti metode atau hubungi support.',
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
        _showPaymentSnack(failure.message, backgroundColor: AppColors.error);
      },
      (data) {
        setState(() {
          _paymentResult = Map<String, dynamic>.from(data);
          _busy = false;
        });
        _showPaymentSnack(
          'Metode diubah ke $_channelLabel',
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
        _showPaymentSnack(failure.message, backgroundColor: AppColors.error);
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
          'Pembayaran berhasil disimulasikan. Anda tetap di halaman ini.',
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
        'Pembayaran terkonfirmasi oleh server.',
        backgroundColor: AppColors.success,
      );
    } else {
      _showPaymentSnack(
        'Pembayaran belum terkonfirmasi. Periksa lagi beberapa saat.',
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
        _showPaymentSnack(failure.message, backgroundColor: AppColors.error);
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
          title: const Text('Keluar halaman?'),
          content: const Text(
            'Pembayaran belum dikonfirmasi lunas. Anda bisa kembali ke instruksi ini dari detail pesanan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Tetap di sini'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Kembali'),
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
        title: 'Instruksi Pembayaran',
        backgroundColor: Colors.white,
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
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_paymentConfirmed) ...[
                    PaymentExpiryBanner(
                      pendingPayment: _paymentResult,
                      orderCreatedAt: widget.orderCreatedAt,
                      paymentStatus: widget.paymentStatus,
                    ),
                    SizedBox(height: 12.h),
                  ],
                  if (_paymentConfirmed) ...[
                    _successBanner(),
                    SizedBox(height: 12.h),
                  ] else if (!_hasPayableInstructionData && !_busy) ...[
                    _missingPaymentDataBanner(),
                    SizedBox(height: 12.h),
                  ],
                  _summaryCard(),
                  if (_orderNumbers.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    _orderNumbersCard(),
                  ],
                  SizedBox(height: 12.h),
                  _selectedMethodBanner(),
                  SizedBox(height: 14.h),
                  _instructionCard(context),
                  SizedBox(height: 14.h),
                  _stepsCard(),
                  if (!_paymentConfirmed &&
                      (_isMockPayment ||
                          (_showSimulateButton && _hasRealPaymentRequest))) ...[
                    SizedBox(height: 12.h),
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
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_paymentConfirmed && !_hasPayableInstructionData) ...[
            SizedBox(height: 8.h),
            CustomButton(
              text: 'Generate VA / Muat Ulang',
              backgroundColor: AppColors.primary,
              onPressed: _busy ? null : _regeneratePaymentInstructions,
            ),
          ],
          if (_showSimulateButton && !_paymentConfirmed) ...[
            CustomButton(
              text: 'Simulasi Pembayaran Lunas',
              backgroundColor: AppColors.warning,
              onPressed: _busy ? null : _simulatePayment,
            ),
            if (!_isMockPayment && kDebugMode && _hasRealPaymentRequest)
              Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                child: Text(
                  'Memanggil Xendit test simulate — pastikan webhook Payment Requests v3 aktif.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else if (!_isMockPayment && kDebugMode)
              Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                child: Text(
                  'Hanya berhasil untuk Payment Request mock atau Xendit test mode.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              SizedBox(height: 8.h),
          ],
          if (!_paymentConfirmed) ...[
            CustomButton(
              text: 'Ganti Metode Pembayaran',
              isOutlined: true,
              onPressed: _busy ? null : _changePaymentMethod,
            ),
            SizedBox(height: 8.h),
          ],
          CustomButton(
            text: _paymentConfirmed
                ? (_isBatchPayment
                    ? 'Lihat Pesanan Saya'
                    : 'Kembali ke Detail Pesanan')
                : 'Kembali',
            useGradient: true,
            onPressed: (_busy || _blockExitTap) ? null : _handleLeavePage,
          ),
          SizedBox(height: 4.h),
          if (!_paymentConfirmed)
            TextButton(
              onPressed: _busy ? null : _cancelPayment,
              child: Text(
                'Batalkan Pembayaran',
                style: TextStyle(
                  fontSize: 13.sp,
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.triangleAlert, size: 22.sp, color: AppColors.warning),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VA/QR belum tersedia',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.warning,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Pembayaran belum selesai di-generate. Tap "Generate VA / Muat Ulang" atau ganti metode.',
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, size: 22.sp, color: AppColors.success),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pembayaran Berhasil',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Pesanan sedang diproses. Anda tetap di halaman ini — tap "Kembali ke Detail Pesanan" bila sudah selesai.',
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.flaskConical, size: 18.sp, color: AppColors.warning),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Mode simulasi — gunakan tombol "Simulasi Pembayaran Lunas" untuk test (mock langsung, atau Xendit /v3/simulate di test mode).',
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Pembayaran',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Rp ${_formatAmount(widget.amount)}',
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _channelCode.isEmpty ? 'PEMBAYARAN' : _channelCode,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.receiptText, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                isBatch ? 'No. Pesanan (${numbers.length})' : 'No. Pesanan',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10.r),
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
            borderRadius: BorderRadius.circular(8.r),
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(_channelIcon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metode dipilih',
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
      return _vaCard(label: 'Kode Pembayaran', value: _vaNumber ?? '-');
    }
    return _vaCard(label: 'Nomor Virtual Account', value: _vaNumber ?? '-');
  }

  Widget _vaCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.landmark, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
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
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(10.r),
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
                                  content: Text('$label disalin'),
                                  backgroundColor: AppColors.success,
                                  duration: const Duration(seconds: 2),
                                  extraBottom: paymentInstructionFooterClearance,
                                );
                              }
                            },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
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
            SizedBox(height: 8.h),
            Text(
              'Nomor Virtual Account belum tersedia. Coba ganti metode atau muat ulang.',
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.qrCode, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'Scan QRIS dengan e-wallet apa saja',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (qrData.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h),
              child: Text(
                'QR belum tersedia. Coba ganti metode atau muat ulang.',
                style: TextStyle(fontSize: 12.sp, color: AppColors.error),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: QrImageView(
                data: qrData,
                size: 220.w,
                backgroundColor: Colors.white,
              ),
            ),
          SizedBox(height: 12.h),
          Text(
            'Pastikan nominal di aplikasi e-wallet sama dengan total tagihan.',
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.wallet, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                'Bayar via E-Wallet $_channelCode',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            url == null
                ? 'Link pembayaran belum tersedia. Coba ganti metode pembayaran.'
                : 'Tap tombol di bawah untuk membuka aplikasi $_channelCode dan menyetujui pembayaran.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          SizedBox(height: 14.h),
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
                            extra: {'url': url, 'title': 'Pembayaran $_channelCode'},
                          );
                          if (!context.mounted) return;
                          final exit = parsePaymentWebViewExit(webResult);
                          if (exit != PaymentWebViewExit.failed) {
                            await _pollPaymentFromServer();
                          }
                        }
                      } catch (_) {
                        _showError('Gagal membuka aplikasi pembayaran.');
                      }
                    },
              icon: Icon(LucideIcons.externalLink, size: 18.sp),
              label: const Text('Buka Aplikasi Pembayaran'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.grey200,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
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
        ? const [
            'Buka aplikasi e-wallet / mobile banking yang mendukung QRIS.',
            'Pilih menu Scan QR / Bayar QRIS.',
            'Scan kode QR di atas, periksa nominal, lalu konfirmasi.',
            'Tunggu notifikasi pembayaran berhasil — pesanan otomatis ter-update.',
          ]
        : type == 'EWALLET'
            ? const [
                'Tap "Buka Aplikasi Pembayaran" di atas.',
                'Login ke akun e-wallet Anda bila diminta.',
                'Periksa total tagihan & konfirmasi pembayaran.',
                'Kembali ke aplikasi BISA — pesanan akan otomatis ter-update.',
              ]
            : type == 'OVER_THE_COUNTER'
                ? const [
                    'Datang ke gerai (Alfamart / Indomaret) terdekat.',
                    'Sebutkan ingin bayar via Xendit dengan kode di atas.',
                    'Bayar nominal pas sesuai total tagihan.',
                    'Simpan struk sebagai bukti — status otomatis ter-update.',
                  ]
                : const [
                    'Buka aplikasi mobile banking / ATM bank Anda.',
                    'Pilih menu Transfer → Virtual Account.',
                    'Masukkan nomor VA di atas.',
                    'Periksa total tagihan, lalu konfirmasi.',
                    'Status pesanan otomatis ter-update setelah pembayaran berhasil.',
                  ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.listOrdered, color: AppColors.primary, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                'Cara Bayar',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...List.generate(steps.length, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
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
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
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
}
