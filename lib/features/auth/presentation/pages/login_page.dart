import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../bloc/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  // SEC-MOB-001: password TIDAK BOLEH disimpan di SharedPreferences (plaintext).
  // Sekarang hanya email yang di-remember. Saat upgrade dari versi lama, kita
  // hapus key `remember_password` agar credential lama yang masih tertinggal
  // di prefs dibersihkan sekali.
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    // One-time cleanup of legacy plaintext password (SEC-MOB-001 migration).
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
    // Defense-in-depth: pastikan password legacy tidak tertinggal.
    await prefs.remove('remember_password');
  }

  void _fillDemoCredentials({required bool buyer}) {
    setState(() {
      _emailController.text = buyer ? _demoBuyerEmail : _demoSupplierEmail;
      _passwordController.text = _demoPassword;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) => context.go('/'),
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
        child: Stack(
          children: [
            // Mesh Gradient Background
            _buildMeshBackground(),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.h),

                      // Brand Logo & Back for Guests
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_buildBrandLogo(), _buildGuestButton()],
                      ),

                      SizedBox(height: 48.h),

                      // Welcome Text
                      Text(
                        'welcome'.tr(),
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -1.2,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'login_subtitle'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Input Fields Card
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                _buildForgotPassword(),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            _buildLoginButton(),
                            if (kDebugMode) ...[
                              SizedBox(height: 14.h),
                              _buildDemoQuickFillRow(),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Social Login Section
                      _buildSocialSection(),

                      SizedBox(height: 40.h),

                      // Register Footer
                      _buildRegisterFooter(),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeshBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -50.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: AppColors.softShadow,
      ),
      child: BisaLogo(width: 88.w, height: 36.h),
    );
  }

  Widget _buildGuestButton() {
    return TextButton.icon(
      onPressed: () => context.go('/'),
      icon: Icon(LucideIcons.arrowRight, size: 16.sp, color: AppColors.primary),
      label: Text(
        'Tamu',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          fontSize: 13.sp,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () => context.push('/forgot-password'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'forgot_password'.tr(),
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CustomButton(
          text: 'login1'.tr(),
          useGradient: true,
          isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _saveCredentials();
              if (!context.mounted) return;
              context.read<AuthCubit>().login(
                _emailController.text.trim(),
                _passwordController.text,
              );
            }
          },
        );
      },
    );
  }

  /// Isi cepat akun demo (hanya debug / hackathon).
  Widget _buildDemoQuickFillRow() {
    return Row(
      children: [
        Expanded(
          child: _demoFillChip(
            label: 'Demo Buyer',
            icon: LucideIcons.shoppingBag,
            onTap: () => _fillDemoCredentials(buyer: true),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _demoFillChip(
            label: 'Demo Supplier',
            icon: LucideIcons.store,
            onTap: () => _fillDemoCredentials(buyer: false),
          ),
        ),
      ],
    );
  }

  Widget _demoFillChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.primaryLight.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
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

  Widget _buildSocialSection() {
    return Column(
      children: [
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
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(
                  label: 'google_1'.tr(),
                  onTap: isLoading
                      ? null
                      : () => context.read<AuthCubit>().loginWithGoogle(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _socialIcon({
    required String label,
    String? comingSoonLabel,
    VoidCallback? onTap,
  }) {
    final isDisabled = comingSoonLabel != null;
    return Expanded(
      child: Opacity(
        opacity: isDisabled ? 0.65 : 1,
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.grey200),
          ),
          child: InkWell(
            onTap: isDisabled ? null : onTap,
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
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (comingSoonLabel != null) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      comingSoonLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterFooter() {
    return Center(
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
            onTap: () => context.go('/register'),
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
    );
  }
}
