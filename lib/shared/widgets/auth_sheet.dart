import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/router.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'bisa_logo.dart';

class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AuthSheet(),
      ),
    );
  }

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  static const _demoBuyerEmail = 'h.wijaya@surabayaindustrial.com';
  static const _demoSupplierEmail = 'siti.aminah@agritech.com';
  static const _demoPassword = 'password123';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // SEC-MOB-001: password TIDAK disimpan di SharedPreferences.
  // Hanya email yang di-remember. Legacy `remember_password` key dibersihkan.
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('remember_password')) {
      await prefs.remove('remember_password');
    }
    final savedEmail = prefs.getString('remember_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('remember_email', _emailController.text.trim());
    } else {
      await prefs.remove('remember_email');
    }
    await prefs.remove('remember_password');
  }

  void _fillDemoCredentials({required bool buyer}) {
    setState(() {
      _emailController.text = buyer ? _demoBuyerEmail : _demoSupplierEmail;
      _passwordController.text = _demoPassword;
    });
  }

  /// Tutup sheet lalu [goRouter.go] di frame berikutnya — hindari route kosong / layar putih.
  void _closeSheetAndGo(String location) {
    Navigator.of(context, rootNavigator: true).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goRouter.go(location);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) {
            Navigator.pop(context); // Close sheet on success
          },
          error: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.r),
            ),
          ),
          orElse: () {},
        );
      },
      child: SafeArea(
        top: false,
        child: Container(
        padding: EdgeInsets.fromLTRB(
          24.w,
          16.h,
          24.w,
          24.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BisaLogo(width: 30.w, height: 20.h),
                    SizedBox(width: 2.w),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 18.r,
                      constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                      padding: EdgeInsets.zero,
                      icon: Icon(LucideIcons.x, color: AppColors.grey500, size: 18.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'Masuk ke BISA',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Silakan masuk untuk melanjutkan transaksi.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32.h),
                CustomTextField(
                  label: 'email_1'.tr().tr(),
                  hint: 'emailhint_1'.tr().tr().tr(),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: LucideIcons.mail,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  label: 'password1'.tr().tr().tr(),
                  hint: 'passwordhint_1'.tr().tr().tr(),
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: LucideIcons.lock,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Ingat Saya',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _closeSheetAndGo('/forgot-password'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'forgot_password'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'login1'.tr().tr().tr(),
                      useGradient: true,
                      isLoading: state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _saveCredentials();
                          if (mounted) {
                            context.read<AuthCubit>().login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          }
                        }
                      },
                    );
                  },
                ),
                if (kDebugMode) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _demoFillChip(
                          label: 'Demo Buyer',
                          onTap: () => _fillDemoCredentials(buyer: true),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _demoFillChip(
                          label: 'Demo Supplier',
                          onTap: () => _fillDemoCredentials(buyer: false),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 24.h),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.grey200)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'or_continue_with'.tr(),
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.grey200)),
                  ],
                ),
                SizedBox(height: 24.h),
                Container(
                  height: 54.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: InkWell(
                    onTap: () => context.read<AuthCubit>().loginWithGoogle(),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(
                          'https://www.vectorlogo.zone/logos/google/google-icon.svg',
                          width: 20.w,
                          height: 20.w,
                          placeholderBuilder: (context) => Icon(
                            Icons.g_mobiledata_rounded,
                            size: 24.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Google',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'no_account'.tr(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _closeSheetAndGo('/register'),
                        child: Text(
                          'register_now'.tr(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
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
      ),
    );
  }

  Widget _demoFillChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
