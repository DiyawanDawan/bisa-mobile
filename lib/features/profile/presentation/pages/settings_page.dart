import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_version.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/app_version_label.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/language_picker_sheet.dart';
import '../../../../shared/widgets/currency_selector_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'profile.settings_title'.tr(),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final notificationsOn = authState.maybeWhen(
            authenticated: (user) => user.enableNotifications,
            orElse: () => true,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('profile.settings_section_preferences'.tr()),
                SizedBox(height: 12.h),
                _settingsCard([
                  _settingsItem(
                    LucideIcons.languages,
                    'profile.settings_change_language'.tr(),
                    'profile.settings_choose_language'.tr(),
                    () => showLanguagePickerSheet(context),
                  ),
                  _settingsItem(
                    LucideIcons.banknote,
                    'commerce.display_currency_title'.tr(),
                    'commerce.display_currency_settings_subtitle'.tr(),
                    () => showCurrencySelectorSheet(context),
                  ),
                  _settingsItem(
                    LucideIcons.bell,
                    'profile.settings_notifications_title'.tr(),
                    'profile.settings_notifications_subtitle'.tr(),
                    null,
                    trailing: Switch.adaptive(
                      value: notificationsOn,
                      activeColor: AppColors.primary,
                      onChanged: _notifBusy
                          ? null
                          : (val) async {
                              final loggedIn = authState.maybeWhen(
                                authenticated: (_) => true,
                                orElse: () => false,
                              );
                              if (!loggedIn) {
                                context.push('/login');
                                return;
                              }
                              setState(() => _notifBusy = true);
                              await context
                                  .read<AuthCubit>()
                                  .updateEnableNotifications(val);
                              if (mounted) setState(() => _notifBusy = false);
                            },
                    ),
                  ),
                ]),
                SizedBox(height: 16.h),
                _sectionTitle('profile.settings_section_security'.tr()),
                SizedBox(height: 8.h),
                _settingsCard([
                  _settingsItem(
                    LucideIcons.lock,
                    'profile.menu_change_password'.tr(),
                    'profile.settings_change_password_subtitle'.tr(),
                    () {
                      final loggedIn = authState.maybeWhen(
                        authenticated: (_) => true,
                        orElse: () => false,
                      );
                      context.push(loggedIn ? '/change-password' : '/login');
                    },
                  ),
                  _settingsItem(
                    LucideIcons.shieldCheck,
                    'profile.settings_privacy_title'.tr(),
                    'profile.settings_privacy_subtitle'.tr(),
                    () => context.push('/privacy'),
                  ),
                ]),
                SizedBox(height: 16.h),
                _sectionTitle('profile.settings_section_about'.tr()),
                SizedBox(height: 8.h),
                _settingsCard([
                  FutureBuilder<String>(
                    future: AppVersion.fullLabel,
                    builder: (context, snapshot) => _settingsItem(
                      LucideIcons.info,
                      'profile.settings_app_version_title'.tr(),
                      snapshot.data ?? 'profile.loading'.tr(),
                      null,
                    ),
                  ),
                  _settingsItem(
                    LucideIcons.fileText,
                    'profile.menu_terms'.tr(),
                    'profile.settings_terms_subtitle'.tr(),
                    () => context.push('/terms'),
                  ),
                  _settingsItem(
                    LucideIcons.shieldAlert,
                    'profile.menu_privacy'.tr(),
                    'profile.settings_privacy_policy_subtitle'.tr(),
                    () => context.push('/privacy'),
                  ),
                ]),
                SizedBox(height: 40.h),
                Center(child: BisaLogo(width: 64.w, height: 28.h)),
                SizedBox(height: 12.h),
                const Center(child: AppVersionLabel()),
                SizedBox(height: 6.h),
                Center(
                  child: Text(
                    'profile.settings_copyright'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _settingsCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Column(
            children: [
              item,
              if (idx < items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(
                    height: 1,
                    color: AppColors.grey100.withOpacity(0.5),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _settingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  LucideIcons.chevronRight,
                  size: 18.sp,
                  color: AppColors.grey300,
                )
              : null),
    );
  }

}
