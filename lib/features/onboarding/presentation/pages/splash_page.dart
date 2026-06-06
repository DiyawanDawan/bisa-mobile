import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../../core/network/token_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final prefs = sl<SharedPreferences>();
    final bool showOnboarding = prefs.getBool('show_onboarding') ?? true;

    if (showOnboarding) {
      context.go('/onboarding');
      return;
    }

    final hasToken = await sl<TokenRepository>().hasToken();
    if (!mounted) return;
    if (hasToken) {
      final authResult = await sl<AuthRepository>().getCurrentUser();
      if (!mounted) return;
      final valid = authResult.fold((_) => false, (_) => true);
      if (!valid) {
        await sl<AuthRepository>().logout();
        if (!mounted) return;
        context.go('/login');
        return;
      }
    }

    context.go('/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogoBadge(),
                      SizedBox(height: 32.h),
                      Text(
                        'BISA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Biochart indonesia Sirkular Agritectur',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBadge() {
    return Container(
      width: 156.w,
      height: 156.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(26.w),
      child: Image.asset(
        AppAssets.logo,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.eco,
          size: 64.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
