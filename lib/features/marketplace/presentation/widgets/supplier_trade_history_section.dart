import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';

class SupplierTradeHistorySection extends StatefulWidget {
  const SupplierTradeHistorySection({super.key, required this.supplierId});

  final String supplierId;

  @override
  State<SupplierTradeHistorySection> createState() =>
      _SupplierTradeHistorySectionState();
}

class _SupplierTradeHistorySectionState extends State<SupplierTradeHistorySection> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await sl<ApiClient>().dio.get(
        '/suppliers/${widget.supplierId}/trade-stats',
      );
      if (!mounted) return;
      setState(() {
        _stats = Map<String, dynamic>.from(res.data['data'] as Map);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: const LinearProgressIndicator(minHeight: 2),
      );
    }
    if (_stats == null) return const SizedBox.shrink();

    final total = _stats!['totalTransactions'] ?? 0;
    final completed = _stats!['completedOrders'] ?? 0;
    final rate = _stats!['completionRate'];
    final avgHours = _stats!['avgResponseHours'];

    if (total == 0 && rate == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md12),
      padding: EdgeInsets.all(AppSpacing.section),
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
              Icon(LucideIcons.chartColumn, size: 18.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Text(
                'marketplace.trade_history_title'.tr(),
                style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  'marketplace.trade_total'.tr(),
                  '$total',
                  LucideIcons.shoppingBag,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _statTile(
                  'marketplace.trade_completed'.tr(),
                  '$completed',
                  LucideIcons.circleCheck,
                ),
              ),
            ],
          ),
          if (rate != null || avgHours != null) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (rate != null)
                  Expanded(
                    child: _statTile(
                      'marketplace.trade_completion_rate'.tr(),
                      '$rate%',
                      LucideIcons.percent,
                    ),
                  ),
                if (rate != null && avgHours != null) SizedBox(width: AppSpacing.sm),
                if (avgHours != null)
                  Expanded(
                    child: _statTile(
                      'marketplace.trade_avg_response'.tr(),
                      'marketplace.trade_hours'.tr(namedArgs: {'hours': '$avgHours'}),
                      LucideIcons.clock,
                    ),
                  ),
              ],
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          Text(
            'marketplace.trade_history_hint'.tr(),
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.primary),
          SizedBox(height: 6.h),
          Text(value, style: AppTextStyles.body(fontWeight: FontWeight.w800)),
          Text(label, style: AppTextStyles.caption()),
        ],
      ),
    );
  }
}
