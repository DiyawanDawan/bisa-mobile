import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_version.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/app_version_label.dart';
import '../../../../shared/widgets/bisa_logo.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        backgroundColor: AppColors.white,
        title: 'Pengaturan',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Preferensi'),
            SizedBox(height: 12.h),
            _settingsCard([
              _settingsItem(
                LucideIcons.languages,
                'Bahasa',
                'Pilih bahasa aplikasi',
                () => _showLanguageBottomSheet(context),
              ),
              _settingsItem(
                LucideIcons.bell,
                'Notifikasi',
                'Atur pemberitahuan Anda',
                () {},
                trailing: Switch.adaptive(
                  value: true,
                  activeColor: AppColors.primary,
                  onChanged: (val) {},
                ),
              ),
            ]),
            SizedBox(height: 16.h),
            _sectionTitle('Keamanan'),
            SizedBox(height: 8.h),
            _settingsCard([
              _settingsItem(
                LucideIcons.lock,
                'Ubah Kata Sandi',
                'Perbarui kata sandi Anda',
                () => context.push('/change-password'),
              ),
              _settingsItem(
                LucideIcons.shieldCheck,
                'Privasi & Keamanan',
                'Atur privasi data Anda',
                () {},
              ),
            ]),
            SizedBox(height: 16.h),
            _sectionTitle('Tentang BISA'),
            SizedBox(height: 8.h),
            _settingsCard([
              FutureBuilder<String>(
                future: AppVersion.fullLabel,
                builder: (context, snapshot) => _settingsItem(
                  LucideIcons.info,
                  'Versi Aplikasi',
                  snapshot.data ?? 'Memuat...',
                  null,
                ),
              ),
              _settingsItem(
                LucideIcons.fileText,
                'Syarat & Ketentuan',
                'Baca aturan main BISA',
                () => context.push('/terms'),
              ),
              _settingsItem(
                LucideIcons.shieldAlert,
                'Kebijakan Privasi',
                'Cara kami melindungi data Anda',
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
                'BISA B2B Platform © 2026',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget item = entry.value;
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final currentLocale = context.locale;
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Bahasa',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              _langTile(
                context,
                'Bahasa Indonesia',
                'id',
                'ID',
                currentLocale.languageCode == 'id',
              ),
              _langTile(
                context,
                'English (US)',
                'en',
                'US',
                currentLocale.languageCode == 'en',
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _langTile(
    BuildContext context,
    String title,
    String code,
    String country,
    bool selected,
  ) {
    return ListTile(
      onTap: () {
        context.setLocale(Locale(code, country));
        Navigator.pop(context);
      },
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          color: selected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: selected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
    );
  }
}
