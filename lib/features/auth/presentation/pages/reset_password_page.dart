import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../bloc/auth_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        backgroundColor: AppColors.transparent,
        showShadow: false,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (message) {
              showSuccessSnackBar(context, message);
              context.go('/login');
            },
            error: (message) => showErrorSnackBar(context, message),
            orElse: () {},
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 32.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'auth.reset_password_title'.tr(),
                    style: TextStyle(
                      fontSize: 28.sp, 
                      fontWeight: FontWeight.w800, 
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'auth.reset_password_subtitle'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp, 
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    label: 'kata_sandi_baru'.tr(),
                    hint: 'masukkan_kata_sandi_baru'.tr(),
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'password_required'.tr();
                      if (value.length < 6) return 'password_min'.tr();
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    label: 'konfirmasi_kata_sandi'.tr(),
                    hint: 'ulangi_kata_sandi_baru'.tr(),
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.shield_outlined,
                    validator: (value) {
                      if (value != _passwordController.text) return 'auth.password_mismatch'.tr();
                      return null;
                    },
                  ),
                  SizedBox(height: 48.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'simpan_kata_sandi'.tr(),
                        useGradient: true,
                        isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().resetPasswordWithToken(
                                  widget.token,
                                  _passwordController.text,
                                );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
