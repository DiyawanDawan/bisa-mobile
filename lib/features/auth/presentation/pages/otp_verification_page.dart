import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../bloc/auth_cubit.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String type; // 'EMAIL_VERIFICATION' or 'RESET_PASSWORD'

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.type,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

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
              if (widget.type == 'EMAIL_VERIFICATION') {
                showSuccessSnackBar(context, message);
                context.go('/login');
              }
            },
            resetTokenReceived: (token) {
              context.push('/reset-password', extra: {'token': token});
            },
            error: (message) => showErrorSnackBar(context, message),
            orElse: () {},
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.sectionGapLarge),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    size: 32.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'auth.otp_verify_title'.tr(),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 12.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'masukkan_6_digit_kode_yang_tel'.tr()),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.spacious),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: AppColors.softShadow,
                      ),
                    ),
                    separatorBuilder: (index) => SizedBox(width: 8.w),
                    onCompleted: (pin) {
                      if (widget.type == 'EMAIL_VERIFICATION') {
                        context.read<AuthCubit>().verifyRegistration(
                          widget.email,
                          pin,
                        );
                      } else {
                        context.read<AuthCubit>().verifyResetCode(
                          widget.email,
                          pin,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.spacious),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'verifikasi_sekarang'.tr(),
                      useGradient: true,
                      isLoading: state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ),
                      onPressed: () {
                        if (_pinController.text.length == 6) {
                          if (widget.type == 'EMAIL_VERIFICATION') {
                            context.read<AuthCubit>().verifyRegistration(
                              widget.email,
                              _pinController.text,
                            );
                          } else {
                            context.read<AuthCubit>().verifyResetCode(
                              widget.email,
                              _pinController.text,
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: AppSpacing.sectionGapLarge),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'auth.otp_no_code'.tr(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.read<AuthCubit>().resendOtp(
                          widget.email,
                          widget.type,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        child: Text(
                          'auth.otp_resend'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
