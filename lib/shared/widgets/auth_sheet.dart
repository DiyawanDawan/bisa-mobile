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
      builder: (_) => const AuthSheet(),
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
            Navigator.pop(context);
          },
          error: (message) => showErrorSnackBar(context, message),
          orElse: () {},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.xxlPx.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: bisaSheetPadding(
            context,
            horizontal: AppSpacing.xl,
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md12,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: BisaLogo(width: 72.w, height: 28.h),
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.grey100,
                        foregroundColor: AppColors.grey600,
                      ),
                      icon: Icon(LucideIcons.x, size: 18.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
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
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _rememberMe = !_rememberMe),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() => _rememberMe = value ?? false);
                                },
                                activeColor: AppColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                'auth.remember_me'.tr(),
                                style: AppTextStyles.bodySm(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _closeSheetAndGo('/forgot-password'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                        if (!_formKey.currentState!.validate()) return;
                        final cubit = context.read<AuthCubit>();
                        await _saveCredentials();
                        if (!mounted) return;
                        cubit.login(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
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
                        icon: LucideIcons.shoppingBag,
                        onTap: () => _fillDemoCredentials(buyer: true),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _demoFillChip(
                        label: 'auth.demo_supplier'.tr(),
                        icon: LucideIcons.store,
                        onTap: () => _fillDemoCredentials(buyer: false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xxl),
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
                SizedBox(height: AppSpacing.lg),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    return Row(
                      children: [
                        _socialButton(
                          label: 'shared.google_sign_in'.tr(),
                          iconUrl:
                              'https://www.vectorlogo.zone/logos/google/google-icon.svg',
                          fallback: Icons.g_mobiledata_rounded,
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () => context.read<AuthCubit>().loginWithGoogle(),
                        ),
                        SizedBox(width: AppSpacing.md),
                        _socialButton(
                          label: 'facebook_1'.tr(),
                          iconUrl:
                              'https://www.vectorlogo.zone/logos/facebook/facebook-icon.svg',
                          fallback: Icons.facebook,
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () => context
                                    .read<AuthCubit>()
                                    .loginWithFacebook(),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: AppSpacing.xl),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
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

  Widget _demoFillChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.primaryLight.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySecondary(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required String iconUrl,
    required IconData fallback,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Ink(
            height: 52.h,
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
}
