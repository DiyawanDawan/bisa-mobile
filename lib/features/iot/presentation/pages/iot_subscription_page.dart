import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/network/api_client.dart';
import 'package:mobile_bisa/core/utils/payment_status_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/core/utils/pro_subscription.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/iot/presentation/bloc/iot_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/pro_tier_matrix.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class IotSubscriptionPage extends StatefulWidget {
  const IotSubscriptionPage({super.key});

  @override
  State<IotSubscriptionPage> createState() => _IotSubscriptionPageState();
}

class _IotSubscriptionPageState extends State<IotSubscriptionPage> {
  List<Map<String, dynamic>> _channels = [];
  bool _loadingChannels = true;
  String? _channelsError;
  String? _selectedChannelCode;
  String? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _fetchChannels();
  }

  Future<void> _fetchChannels() async {
    setState(() {
      _loadingChannels = true;
      _channelsError = null;
    });
    try {
      final response = await sl<ApiClient>().dio.get('/payments/channels');
      final raw = response.data['data'] as List? ?? [];
      final channels = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      if (!mounted) return;
      setState(() {
        _channels = channels;
        _loadingChannels = false;
        if (channels.isNotEmpty) {
          _selectedChannelCode = channels.first['code']?.toString();
          _selectedMethod = channels.first['group']?.toString() ?? 'E_WALLET';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingChannels = false;
        _channelsError = 'iot.subscription_channels_error'.tr();
      });
    }
  }

  bool _isProExpired(UserEntity user) {
    if (user.tier != 'PRO') return false;
    if (user.subscriptionExpiresAt == null) return true;
    return user.subscriptionExpiresAt!.isBefore(DateTime.now());
  }

  Future<bool> _pollProSubscriptionStatus() async {
    for (var i = 0; i < 10; i++) {
      await context.read<AuthCubit>().checkAuth();
      if (!mounted) return false;
      final user = context.read<AuthCubit>().state.maybeWhen(
        authenticated: (u) => u,
        orElse: () => null,
      );
      if (user != null && isProActive(user)) return true;
      if (i < 9) {
        await Future.delayed(const Duration(seconds: 3));
      }
    }
    return false;
  }

  IconData _channelIcon(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return LucideIcons.wallet;
      case 'QRIS':
        return LucideIcons.qrCode;
      case 'BANK_TRANSFER':
        return LucideIcons.landmark;
      case 'CREDIT_CARD':
        return LucideIcons.creditCard;
      default:
        return LucideIcons.creditCard;
    }
  }

  String _groupLabel(String? group) {
    switch (group?.toUpperCase()) {
      case 'E_WALLET':
        return 'E-Wallet';
      case 'QRIS':
        return 'QRIS';
      case 'BANK_TRANSFER':
        return 'Transfer Bank';
      case 'CREDIT_CARD':
        return 'Kartu Kredit';
      case 'CASH':
        return 'Tunai';
      default:
        return group ?? 'Pembayaran';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    final isActive = user != null && isProActive(user);
    final isExpired = user != null && _isProExpired(user);
    final isRenewal = isActive || isExpired;

    // Pertahanan in-depth: Pro = fitur khusus Supplier (IoT, analitik bisnis).
    // Jika Buyer membuka /iot-subscription via deep-link / navigasi lama,
    // tampilkan halaman informasi saja, bukan flow upgrade.
    if (user != null && user.role != 'SUPPLIER') {
      return _buildBuyerNotAllowedScreen(context);
    }

    return BlocProvider(
      create: (context) => sl<IotCubit>(),
      child: BlocConsumer<IotCubit, IotState>(
        listener: (context, state) {
          state.maybeWhen(
            subscriptionSuccess: (data) async {
              final pmData = data['paymentData'];
              String? url;
              if (pmData != null && pmData['actions'] != null) {
                final actions = pmData['actions'] as List;
                if (actions.isNotEmpty) {
                  url = actions.first['url'];
                }
              }
              url ??= data['paymentUrl'] ?? data['invoiceUrl'];

              if (url != null) {
                final result = await context.push(
                  '/payment-webview',
                  extra: {
                    'url': url,
                    'title': isRenewal
                        ? 'iot.subscription_payment_renew_webview'.tr()
                        : 'iot.subscription_payment_new_webview'.tr(),
                  },
                );
                if (!mounted) return;
                final exit = parsePaymentWebViewExit(result);
                if (exit == PaymentWebViewExit.failed) {
                  showErrorSnackBar(context, 'iot.payment_failed_body'.tr());
                  return;
                }
                if (exit == PaymentWebViewExit.callbackDetected ||
                    exit == PaymentWebViewExit.dismissed) {
                  final upgraded = await _pollProSubscriptionStatus();
                  if (!mounted) return;
                  if (upgraded) {
                    showSuccessSnackBar(
                      context,
                      isRenewal
                          ? 'iot.subscription_payment_success_renew'.tr()
                          : 'iot.subscription_payment_success_new'.tr(),
                    );
                    context.pop(true);
                  } else {
                    showWarningSnackBar(
                      context,
                      'iot.subscription_payment_pending'.tr(),
                    );
                  }
                }
              } else {
                showErrorSnackBar(context, 'iot.payment_link_failed'.tr());
              }
            },
            error: (message) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('iot.payment_failed_title'.tr()),
                  content: Text(localizeFailureMessage(message)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('iot.close'.tr()),
                    ),
                  ],
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: isRenewal
                  ? 'iot.subscription_renew_title'.tr()
                  : 'iot.subscription_plan_title'.tr(),
              backgroundColor: AppColors.surface,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: fullScreenScrollPadding(
                    context,
                    horizontal: 20,
                    top: 20,
                    baseBottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isActive && user.subscriptionExpiresAt != null)
                        _buildActiveStatusCard(user.subscriptionExpiresAt!),
                      if (isExpired && user.subscriptionExpiresAt != null)
                        _buildExpiredStatusCard(user.subscriptionExpiresAt!),
                      _buildHeaderCard(isRenewal: isRenewal),
                      SizedBox(height: AppSpacing.xl),
                      Text(
                        'pro.matrix_section_title'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md12),
                      const ProTierMatrix(),
                      SizedBox(height: AppSpacing.xl),
                      Text(
                        'iot.subscription_benefits_title'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md12),
                      _buildFeatureItem(
                        LucideIcons.thermometer,
                        'iot.subscription_feature_temp_title'.tr(),
                        'iot.subscription_feature_temp_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.bellRing,
                        'iot.subscription_feature_alert_title'.tr(),
                        'iot.subscription_feature_alert_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.chartBar,
                        'iot.subscription_feature_analytics_title'.tr(),
                        'iot.subscription_feature_analytics_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.sparkles,
                        'iot.subscription_feature_market_title'.tr(),
                        'iot.subscription_feature_market_desc'.tr(),
                      ),
                      _buildFeatureItem(
                        LucideIcons.map,
                        'iot.subscription_feature_gis_title'.tr(),
                        'iot.subscription_feature_gis_desc'.tr(),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Text(
                        'iot.subscription_pick_payment'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md12),
                      _buildPaymentMethodsList(),
                      SizedBox(height: AppSpacing.xxl),
                      CustomButton(
                        text: isActive
                            ? 'iot.subscription_renew_cta'.tr()
                            : isExpired
                            ? 'iot.subscription_renew_now_cta'.tr()
                            : 'iot.subscription_activate_cta'.tr(),
                        useGradient: true,
                        onPressed:
                            _selectedChannelCode == null ||
                                _selectedMethod == null
                            ? null
                            : () {
                                context.read<IotCubit>().subscribePro(
                                  _selectedChannelCode!,
                                  _selectedMethod!,
                                );
                              },
                      ),
                      if (isRenewal) ...[
                        SizedBox(height: AppSpacing.sm10),
                        Text(
                          'iot.subscription_extend_note'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    color: AppColors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    if (_loadingChannels) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: ShimmerListPlaceholder(itemCount: 3, itemHeight: 56.h),
      );
    }

    if (_channelsError != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          children: [
            Text(
              _channelsError!,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            ),
            SizedBox(height: AppSpacing.sm10),
            TextButton(
              onPressed: _fetchChannels,
              child: Text('iot.retry'.tr()),
            ),
          ],
        ),
      );
    }

    if (_channels.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Text(
          'iot.subscription_no_channels'.tr(),
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _channels.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
      itemBuilder: (context, index) {
        final item = _channels[index];
        final code = item['code']?.toString() ?? '';
        final group = item['group']?.toString();
        final isSelected = _selectedChannelCode == code;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedChannelCode = code;
              _selectedMethod = group ?? 'E_WALLET';
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.section,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.tile),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _channelIcon(group),
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                  size: 22.sp,
                ),
                SizedBox(width: AppSpacing.section),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']?.toString() ?? code,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _groupLabel(group),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(LucideIcons.check, color: AppColors.primary)
                else
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey300, width: 2),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveStatusCard(DateTime expiresAt) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, color: AppColors.success, size: 20.sp),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(
              'iot.subscription_pro_active_card'.tr(
                namedArgs: {
                  'date': DateFormat('d MMMM yyyy').format(expiresAt),
                },
              ),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredStatusCard(DateTime expiredAt) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.clockAlert, color: AppColors.warning, size: 20.sp),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(
              'iot.subscription_pro_expired_card'.tr(
                namedArgs: {
                  'date': DateFormat('d MMMM yyyy').format(expiredAt),
                },
              ),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback screen ketika pembeli (Buyer) mengakses halaman ini.
  /// Pro = paket fitur penjual (Supplier) — jadi pembeli diberi info
  /// non-konversi alih-alih flow upgrade berbayar.
  Widget _buildBuyerNotAllowedScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'iot.subscription_bisa_pro_appbar'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.pageGutter,
          vertical: AppSpacing.spacious,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(22.r),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.store,
                size: 48.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'iot.subscription_buyer_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'iot.subscription_buyer_body'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 220.w,
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.arrowLeft, size: 18),
                label: Text('iot.back'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard({required bool isRenewal}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md12,
                  vertical: AppSpacing.xs6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Text(
                  isRenewal
                      ? 'iot.subscription_header_renew_badge'.tr()
                      : 'iot.subscription_header_popular_badge'.tr(),
                  style: TextStyle(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Icon(LucideIcons.crown, color: AppColors.warning, size: 28.sp),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            isRenewal
                ? 'iot.subscription_header_plan_renew'.tr()
                : 'iot.subscription_header_plan_new'.tr(),
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Rp 99.000',
                style: TextStyle(
                  color: AppColors.surface,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'iot.subscription_price_per_month'.tr(),
                style: TextStyle(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: AppSpacing.section),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.5.sp,
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
}
