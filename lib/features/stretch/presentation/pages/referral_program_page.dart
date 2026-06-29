import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../data/datasources/stretch_remote_data_source.dart';

class ReferralProgramPage extends StatefulWidget {
  const ReferralProgramPage({super.key});

  @override
  State<ReferralProgramPage> createState() => _ReferralProgramPageState();
}

class _ReferralProgramPageState extends State<ReferralProgramPage> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await sl<StretchRemoteDataSource>().getReferralDashboard();
      if (mounted) setState(() => _data = data);
    } catch (e) {
      if (mounted) setState(() => _error = 'errors.generic');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'referral.title'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!.tr()))
              : ListView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  children: [
                    _heroCard(),
                    SizedBox(height: AppSpacing.md),
                    _statsRow(),
                    SizedBox(height: AppSpacing.md),
                    CustomButton(
                      text: 'referral.copy_code'.tr(),
                      icon: LucideIcons.copy,
                      useGradient: true,
                      onPressed: () {
                        final code = _data?['referralCode']?.toString() ?? '';
                        Clipboard.setData(ClipboardData(text: code));
                        showSuccessSnackBar(context, 'referral.copied');
                      },
                    ),
                  ],
                ),
    );
  }

  Widget _heroCard() {
    final code = _data?['referralCode']?.toString() ?? '—';
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)]),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('referral.your_code'.tr(), style: TextStyle(color: AppColors.surface, fontSize: 12.sp)),
          SizedBox(height: AppSpacing.sm),
          Text(code, style: TextStyle(color: AppColors.surface, fontSize: 22.sp, fontWeight: FontWeight.w900)),
          SizedBox(height: AppSpacing.sm),
          Text(
            'referral.hint'.tr(namedArgs: {'amount': '${_data?['commissionPerOrder'] ?? 25000}'}),
            style: TextStyle(color: AppColors.surface.withValues(alpha: 0.9), fontSize: 11.sp, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statTile('referral.stat_referrals'.tr(), '${_data?['totalReferrals'] ?? 0}')),
        SizedBox(width: AppSpacing.sm10),
        Expanded(child: _statTile('referral.stat_earned'.tr(), 'Rp ${(_data?['totalEarned'] ?? 0).toString()}')),
      ],
    );
  }

  Widget _statTile(String label, String value) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          SizedBox(height: 6.h),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
