import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/wallet_transaction_entity.dart';

String walletTransactionTitle(WalletTransactionEntity tx) {
  switch (tx.type) {
    case WalletTransactionType.sales:
      return 'wallet.tx_sales_title'.tr(namedArgs: {
        'orderNumber': tx.orderNumber ?? '',
      });
    case WalletTransactionType.payout:
      return 'wallet.tx_payout_title'.tr();
    case WalletTransactionType.subscription:
      return 'wallet.tx_subscription_title'.tr();
    default:
      return 'wallet.tx_default_title'.tr();
  }
}

String walletTransactionStatusText(WalletTransactionStatus status) {
  switch (status) {
    case WalletTransactionStatus.pending:
      return 'wallet.filter_pending'.tr();
    case WalletTransactionStatus.escrowHeld:
      return 'wallet.tx_status_escrow'.tr();
    case WalletTransactionStatus.released:
      return 'wallet.filter_released'.tr();
    case WalletTransactionStatus.refunded:
      return 'wallet.tx_status_refunded'.tr();
    case WalletTransactionStatus.failed:
      return 'wallet.filter_failed'.tr();
    default:
      return 'wallet.tx_status_unknown'.tr();
  }
}

Color walletTransactionStatusColor(WalletTransactionStatus status) {
  switch (status) {
    case WalletTransactionStatus.released:
      return AppColors.success;
    case WalletTransactionStatus.failed:
    case WalletTransactionStatus.refunded:
      return AppColors.error;
    case WalletTransactionStatus.pending:
    case WalletTransactionStatus.escrowHeld:
      return AppColors.warning;
    default:
      return AppColors.textSecondary;
  }
}

void showWalletTransactionDetail(
  BuildContext context,
  WalletTransactionEntity tx,
) {
  final isIncome = tx.type == WalletTransactionType.sales;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (bContext) => Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        20.h + systemBottomInset(bContext),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                color: isIncome ? AppColors.success : AppColors.error,
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: Text(
              walletTransactionTitle(tx),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              '${isIncome ? '+' : '-'} ${formatMoneyIdr(tx.amount)}',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: isIncome ? AppColors.success : AppColors.error,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          _detailRow(
            'wallet.tx_detail_status'.tr(),
            walletTransactionStatusText(tx.status),
            valueColor: walletTransactionStatusColor(tx.status),
          ),
          _detailRow(
            'wallet.tx_detail_date'.tr(),
            DateFormat('dd MMMM yyyy, HH:mm').format(tx.createdAt),
          ),
          _detailRow('wallet.tx_detail_id'.tr(), tx.id),
          if (tx.paymentMethod != null && tx.paymentMethod!.isNotEmpty)
            _detailRow('wallet.tx_detail_method'.tr(), tx.paymentMethod!),
          if (tx.externalId != null && tx.externalId!.isNotEmpty)
            _detailRow('wallet.tx_detail_reference'.tr(), tx.externalId!),
          if (tx.type == WalletTransactionType.sales) ...[
            SizedBox(height: 8.h),
            const Divider(),
            SizedBox(height: 8.h),
            _detailRow('wallet.tx_detail_gross'.tr(), formatMoneyIdr(tx.amount)),
            _detailRow(
              'wallet.tx_detail_platform_fee'.tr(),
              '- ${formatMoneyIdr(tx.platformFee)}',
              valueColor: AppColors.error,
            ),
            _detailRow(
              'wallet.tx_detail_net'.tr(),
              formatMoneyIdr(tx.sellerAmount),
              valueColor: AppColors.success,
              isBold: true,
            ),
          ],
          SizedBox(height: 12.h),
        ],
      ),
    ),
  );
}

Widget _detailRow(
  String label,
  String value, {
  Color? valueColor,
  bool isBold = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.sp,
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class WalletTransactionTile extends StatelessWidget {
  final WalletTransactionEntity tx;
  final EdgeInsetsGeometry? padding;

  const WalletTransactionTile({
    super.key,
    required this.tx,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == WalletTransactionType.sales;

    return GestureDetector(
      onTap: () => showWalletTransactionDetail(context, tx),
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                color: isIncome ? AppColors.success : AppColors.error,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    walletTransactionTitle(tx),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm').format(tx.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'} ${formatMoneyIdr(tx.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isIncome ? AppColors.success : AppColors.error,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  walletTransactionStatusText(tx.status),
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: walletTransactionStatusColor(tx.status),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
