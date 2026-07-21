import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/safe_area_utils.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_feedback.dart';
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
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) => Padding(
        padding: bisaSheetPadding(
          sheetContext,
          horizontal: AppSpacing.xl,
          top: AppSpacing.md,
          bottom: AppSpacing.xl,
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
          error: (message) => showErrorSnackBar(context, message),
          orElse: () {},
        );
      },
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.xxlPx.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
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
                      borderRadius: BorderRadius.circular(AppRadius.md),
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
                  'shared.auth_sheet_title'.tr(),
                  style: AppTextStyles.sheetTitle(),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'shared.auth_sheet_subtitle'.tr(),
                  style: AppTextStyles.body(color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.xxl),
                CustomTextField(
                  label: 'email'.tr(),
                  hint: 'email_hint'.tr(),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: LucideIcons.mail,
                  isRequired: true,
                ),
                SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  label: 'password'.tr(),
                  hint: 'password_hint'.tr(),
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: LucideIcons.lock,
                  isRequired: true,
                ),
                SizedBox(height: AppSpacing.md12),
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
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'auth.remember_me'.tr(),
                          style: AppTextStyles.bodySm(
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
                        style: AppTextStyles.bodySm(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'login'.tr(),
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
                SizedBox(height: AppSpacing.md12),
                Row(
                  children: [
                    Expanded(
                      child: _demoFillChip(
                        label: 'auth.demo_buyer'.tr(),
                        onTap: () => _fillDemoCredentials(buyer: true),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _demoFillChip(
                        label: 'auth.demo_supplier'.tr(),
                        onTap: () => _fillDemoCredentials(buyer: false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.grey200)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'or_continue_with'.tr(),
                        style: AppTextStyles.bodySecondary(
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.grey200)),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    Widget socialBtn({
                      required String label,
                      required String iconUrl,
                      required IconData fallback,
                      required VoidCallback? onTap,
                    }) {
                      return Expanded(
                        child: Material(
                          color: AppColors.transparent,
                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            child: Ink(
                              height: AppSpacing.buttonHeightLg,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppRadius.xl),
                                border: Border.all(color: AppColors.grey200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isLoading)
                                    SizedBox(
                                      width: 18.w,
                                      height: 18.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  else
                                    SvgPicture.network(
                                      iconUrl,
                                      width: 18.w,
                                      height: 18.w,
                                      placeholderBuilder: (context) => Icon(
                                        fallback,
                                        size: 22.sp,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  SizedBox(width: AppSpacing.sm),
                                  Flexible(
                                    child: Text(
                                      label,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.body(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Row(
                      children: [
                        socialBtn(
                          label: 'shared.google_sign_in'.tr(),
                          iconUrl:
                              'https://www.vectorlogo.zone/logos/google/google-icon.svg',
                          fallback: Icons.g_mobiledata_rounded,
                          onTap: isLoading
                              ? null
                              : () => context.read<AuthCubit>().loginWithGoogle(),
                        ),
                        SizedBox(width: AppSpacing.md),
                        socialBtn(
                          label: 'facebook_1'.tr(),
                          iconUrl:
                              'https://www.vectorlogo.zone/logos/facebook/facebook-icon.svg',
                          fallback: Icons.facebook,
                          onTap: isLoading
                              ? null
                              : () =>
                                  context.read<AuthCubit>().loginWithFacebook(),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: AppSpacing.xl),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'no_account'.tr(),
                        style: AppTextStyles.body(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => _closeSheetAndGo('/register'),
                        child: Text(
                          'register_now'.tr(),
                          style: AppTextStyles.body(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
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

  Widget _demoFillChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySecondary(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
