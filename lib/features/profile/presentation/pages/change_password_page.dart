import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showErrorSnackBar(context, 'harap_isi_semua_field'.tr());
      return;
    }

    if (newPassword.length < 8) {
      showErrorSnackBar(context, 'auth.password_min_8'.tr());
      return;
    }

    if (newPassword != confirmPassword) {
      showErrorSnackBar(context, 'konfirmasi_password_tidak_coco'.tr());
      return;
    }

    setState(() => _isLoading = true);

    final result = await sl<AuthRepository>().changePassword(newPassword);

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        showFailureSnackBarFromMessage(context, failure.message);
      },
      (_) {
        showSuccessSnackBar(context, 'password_berhasil_diperbarui'.tr());
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'profile.change_password_title'.tr(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'profile.change_password_info'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            CustomTextField(
              label: 'kata_sandi_baru'.tr(),
              hint: 'masukkan_kata_sandi_baru'.tr(),
              controller: _newPasswordController,
              isPassword: true,
              prefixIcon: LucideIcons.key,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              label: 'konfirmasi_kata_sandi_baru'.tr(),
              hint: 'ulangi_kata_sandi_baru'.tr(),
              controller: _confirmPasswordController,
              isPassword: true,
              prefixIcon: LucideIcons.shieldCheck,
            ),
            SizedBox(height: 40.h),
            CustomButton(
              text: 'simpan_perubahan'.tr(),
              onPressed: _isLoading ? null : _submit,
              isLoading: _isLoading,
              useGradient: true,
            ),
          ],
        ),
      ),
    );
  }
}
