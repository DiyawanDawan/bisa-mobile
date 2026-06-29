import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/market/data/models/market_supply_demand_model.dart';

class MarketSupplyDemandCard extends StatelessWidget {
  final MarketSupplyDemandModel data;
  final bool compact;

  const MarketSupplyDemandCard({
    super.key,
    required this.data,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14.r : 16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!compact) ...[
            Text(
              data.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
          ],
          Row(
            children: [
              _chip(_balanceLabel(data.balance), _balanceColor(data.balance)),
              if (data.supplyDemandRatio != null) ...[
                SizedBox(width: 8.w),
                Text(
                  'market.sd_ratio'.tr(namedArgs: {
                    'ratio': data.supplyDemandRatio!.toStringAsFixed(2),
                  }),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _metric(
                  'market.sd_supply'.tr(),
                  LucideIcons.package,
                  AppColors.primary,
                  [
                    'market.sd_products'.tr(namedArgs: {'n': '${data.productCount}'}),
                    'market.sd_stock_ton'.tr(namedArgs: {
                      'ton': _formatTon(data.totalStockTon),
                    }),
                    'market.sd_provinces'.tr(namedArgs: {'n': '${data.provinceCount}'}),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _metric(
                  'market.sd_demand'.tr(),
                  LucideIcons.shoppingCart,
                  AppColors.secondary,
                  [
                    'market.sd_orders_90d'.tr(namedArgs: {'n': '${data.orderCount90d}'}),
                    'market.sd_open_orders'.tr(namedArgs: {'n': '${data.openOrderCount}'}),
                    'market.sd_weight_ton_90d'.tr(namedArgs: {
                      'ton': _formatTon(data.quantityTon90d),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _metric(String title, IconData icon, Color color, List<String> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ...lines.map(
          (line) => Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Text(
              line,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.35),
            ),
          ),
        ),
      ],
    );
  }

  String _balanceLabel(String balance) {
    switch (balance) {
      case 'oversupply':
        return 'market.sd_oversupply'.tr();
      case 'high_demand':
        return 'market.sd_high_demand'.tr();
      case 'balanced':
        return 'market.sd_balanced'.tr();
      default:
        return 'market.sd_unknown'.tr();
    }
  }

  Color _balanceColor(String balance) {
    switch (balance) {
      case 'oversupply':
        return AppColors.warning;
      case 'high_demand':
        return AppColors.error;
      case 'balanced':
        return AppColors.success;
      default:
        return AppColors.grey400;
    }
  }

  String _formatTon(double ton) {
    return NumberFormat('#,##0.0', 'id_ID').format(ton);
  }
}
