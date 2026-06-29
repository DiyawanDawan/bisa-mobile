import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../bloc/auth_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
            success: (message) => showSuccessSnackBar(context, message),
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
                      Icons.key_rounded,
                      size: 32.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'auth.forgot_password_title'.tr(),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'auth.forgot_password_desc'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    label: 'email'.tr(),
                    hint: 'email_hint'.tr(),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.alternate_email_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'email_required'.tr();
                      if (!value.contains('@')) return 'email_invalid'.tr();
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'kirim_instruksi'.tr(),
                        useGradient: true,
                        isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
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
