import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../utils/checkout_navigation.dart';
import '../bloc/order_cubit.dart';
import '../widgets/payment_method_picker_sheet.dart';

/// Ringkasan pesanan setelah direct checkout (1+ supplier).
/// Pembayaran selalu **satu kali** untuk semua pesanan (batch).
class DirectCheckoutResultPage extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  final String? selectedPaymentCode;

  const DirectCheckoutResultPage({
    super.key,
    required this.orders,
    this.selectedPaymentCode,
  });

  static List<Map<String, dynamic>> ordersFromExtra(Object? extra) {
    if (extra is! Map) return const [];
    final raw = extra['orders'];
    if (raw is! List) return const [];
    return raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  static String? selectedPaymentCodeFromExtra(Object? extra) {
    if (extra is! Map) return null;
    return extra['selectedPaymentCode']?.toString();
  }

  @override
  State<DirectCheckoutResultPage> createState() =>
      _DirectCheckoutResultPageState();
}

class _DirectCheckoutResultPageState extends State<DirectCheckoutResultPage> {
  bool _paying = false;

  List<String> get _orderIds => widget.orders
      .map((o) => o['orderId']?.toString())
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toList();

  double get _batchTotal => widget.orders.fold<double>(
        0,
        (sum, o) {
          final raw = o['totalAmount'];
          if (raw is num) return sum + raw.toDouble();
          return sum + (double.tryParse(raw?.toString() ?? '') ?? 0);
        },
      );

  Future<void> _payAll() async {
    final orderIds = _orderIds;
    if (orderIds.isEmpty) return;

    var channelCode = widget.selectedPaymentCode;
    if (channelCode == null || channelCode.isEmpty) {
      final choice = await PaymentMethodPickerSheet.show(
        context,
        amount: _batchTotal,
      );
      if (choice == null || !mounted) return;
      channelCode = choice.code;
    }

    setState(() => _paying = true);
    final cubit = context.read<OrderCubit>();
    final Map<String, dynamic>? payData;
    if (orderIds.length > 1) {
      payData = await cubit.initializeBatchPayment(orderIds, channelCode);
    } else {
      payData = await cubit.initializePayment(orderIds.first, channelCode);
    }
    if (!mounted) return;
    setState(() => _paying = false);

    if (payData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<OrderCubit>().state.maybeWhen(
                  error: (msg) => msg,
                  orElse: () => 'Gagal inisialisasi pembayaran',
                ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final leadOrderId = payData['leadOrderId']?.toString() ?? orderIds.first;
    final batchTotal = payData['batchTotalAmount'] ?? payData['amount'];
    final orderNumbersRaw = payData['orderNumbers'];
    final checkoutBatchNumber =
        payData['checkoutBatchNumber']?.toString().trim();
    final orderLabel = checkoutBatchNumber?.isNotEmpty == true
        ? checkoutBatchNumber!
        : (orderNumbersRaw is List && orderNumbersRaw.length > 1
            ? '${orderNumbersRaw.length} pesanan checkout'
            : (widget.orders.first['orderNumber']?.toString() ?? 'Checkout'));

    if (!mounted) return;
    context.pushReplacement(
      '/payment-instruction',
      extra: {
        'orderId': leadOrderId,
        'orderNumber': orderLabel,
        'amount': batchTotal,
        'paymentResult': payData,
        if (orderIds.length > 1) 'batchOrderIds': orderIds,
      },
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.orders.length;

    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'Checkout Selesai',
          backgroundColor: Colors.white,
          onBackTap: _goBack,
        ),
        body: ListView(
          padding: fullScreenScrollPadding(
            context,
            horizontal: 20,
            top: 16,
            baseBottom: 24,
          ),
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.circleCheck,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count pesanan dibuat',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Bayar sekali untuk semua toko (${_batchTotal.toRupiah})',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            ...widget.orders.map(_buildOrderTile),
            SizedBox(height: 16.h),
            CustomButton(
              text: _paying ? 'Memproses...' : 'Bayar semua ($_batchTotal.toRupiah)',
              onPressed: _paying ? null : _payAll,
            ),
            SizedBox(height: 10.h),
            CustomButton(
              text: 'Ke Pesanan Saya',
              isOutlined: true,
              onPressed: () => context.go('/?tab=3'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTile(Map<String, dynamic> order) {
    final orderNumber = order['orderNumber']?.toString() ?? '-';
    final sellerName = order['sellerName']?.toString() ?? 'Supplier';
    final raw = order['totalAmount'];
    final amount = raw is num
        ? raw.toDouble()
        : double.tryParse(raw?.toString() ?? '') ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderNumber,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  sellerName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount.toRupiah,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
