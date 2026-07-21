import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  List<Map<String, dynamic>> _channels = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await sl<ApiClient>().dio.get('/payments/channels');
      final raw = response.data['data'] as List? ?? [];
      final channels = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) => (e['isActive'] ?? true) == true)
          .toList();
      if (!mounted) return;
      setState(() {
        _channels = channels;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'profile.payment_load_error'.tr();
      });
    }
  }

  IconData _channelIcon(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return LucideIcons.wallet;
      case 'QRIS':
        return LucideIcons.qrCode;
      case 'BANK_TRANSFER':
      case 'VIRTUAL_ACCOUNT':
        return LucideIcons.landmark;
      case 'CREDIT_CARD':
        return LucideIcons.creditCard;
      case 'CASH':
      case 'OVER_THE_COUNTER':
        return LucideIcons.store;
      default:
        return LucideIcons.creditCard;
    }
  }

  String _groupLabel(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return 'profile.payment_group_ewallet'.tr();
      case 'QRIS':
        return 'profile.payment_group_qris'.tr();
      case 'BANK_TRANSFER':
      case 'VIRTUAL_ACCOUNT':
        return 'profile.payment_group_bank_va'.tr();
      case 'CREDIT_CARD':
        return 'profile.payment_group_credit_card'.tr();
      case 'CASH':
      case 'OVER_THE_COUNTER':
        return 'profile.payment_group_cash'.tr();
      default:
        return group?.replaceAll('_', ' ') ??
            'profile.payment_group_default'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'profile.menu_payment_methods'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ShimmerListPlaceholder(
        itemCount: 5,
        itemHeight: 64.h,
        scrollable: true,
        padding: EdgeInsets.all(16.w),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.spacious),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.circleAlert,
                size: 48.sp,
                color: AppColors.error,
              ),
              SizedBox(height: 12.h),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: _fetchChannels,
                child: Text('profile.retry'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    if (_channels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.creditCard, size: 64.sp, color: AppColors.grey300),
            SizedBox(height: 16.h),
            Text(
              'profile.payment_empty'.tr(),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: _fetchChannels,
              child: Text('profile.retry'.tr()),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.comfortable),
      itemCount: _channels.length,
      itemBuilder: (context, index) => _buildChannelItem(_channels[index]),
    );
  }

  Widget _buildChannelItem(Map<String, dynamic> channel) {
    final code = channel['code']?.toString() ?? '';
    final name = channel['name']?.toString() ?? code;
    final group = channel['group']?.toString();
    final subtitle = _groupLabel(group);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 32.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              _channelIcon(group),
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
                if (code.isNotEmpty)
                  Text(
                    code,
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 10.sp,
                    ),
                  ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, size: 18.sp, color: AppColors.grey400),
        ],
      ),
    );
  }
}
