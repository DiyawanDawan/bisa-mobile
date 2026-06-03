import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_logo.dart';

/// Tinggi area kontrol bawah (indikator + CTA) — dipakai untuk padding teks di slide.
const double _kBottomControlsHeightFactor = 0.28;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = const [
    OnboardingContent(
      stepLabel: 'Marketplace',
      title: 'Marketplace B2B\nBiomassa',
      description:
          'Jelajahi ribuan produk biomassa & hasil tani dari supplier terverifikasi di seluruh Indonesia.',
      imageAsset: AppAssets.onboardingMarketplace,
      icon: LucideIcons.store,
      accent: AppColors.primary,
    ),
    OnboardingContent(
      stepLabel: 'Negosiasi',
      title: 'Negosiasi\nTransparan',
      description:
          'Tawar harga dan volume langsung lewat chat bisnis — cepat, jelas, tanpa ribet.',
      imageAsset: AppAssets.onboardingNegotiate,
      icon: LucideIcons.handshake,
      accent: AppColors.primaryMedium,
    ),
    OnboardingContent(
      stepLabel: 'Insight',
      title: 'Insight Pasar\n& AI',
      description:
          'Pantau tren harga, prediksi pasar, dan rekomendasi untuk keputusan bisnis yang lebih kuat.',
      imageAsset: AppAssets.onboardingInsight,
      icon: LucideIcons.sparkles,
      accent: AppColors.secondary,
    ),
    OnboardingContent(
      stepLabel: 'Aman',
      title: 'Bayar Aman\ndengan Escrow',
      description:
          'Dana terlindungi hingga transaksi selesai. Lacak pesanan dari checkout sampai terima barang.',
      imageAsset: AppAssets.onboardingPayment,
      icon: LucideIcons.shieldCheck,
      accent: AppColors.primaryDark,
    ),
  ];

  bool get _isLastPage => _currentPage == _contents.length - 1;

  Future<void> _completeOnboarding() async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool('show_onboarding', false);
  }

  Future<void> _goToCatalog() async {
    await _completeOnboarding();
    if (mounted) context.go('/?tab=0');
  }

  Future<void> _goToLogin() async {
    await _completeOnboarding();
    if (mounted) context.go('/login');
  }

  void _nextPage() {
    if (_isLastPage) {
      _goToCatalog();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    if (_currentPage == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomPanelHeight =
        MediaQuery.sizeOf(context).height * _kBottomControlsHeightFactor +
            bottomInset;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _contents.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _OnboardingSlide(
                  content: _contents[index],
                  index: index,
                  textBottomPadding: bottomPanelHeight + 12.h,
                );
              },
            ),
            _buildTopBarOverlay(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarOverlay() {
    final top = MediaQuery.paddingOf(context).top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.black.withValues(alpha: 0.55),
              Colors.transparent,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, top + 8.h, 12.w, 20.h),
          child: Row(
            children: [
              BisaLogo(width: 76.w, height: 34.h),
              const Spacer(),
              TextButton(
                onPressed: _goToCatalog,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Lewati',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_contents.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 6.h,
                  width: active ? 28.w : 8.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: active ? AppColors.primaryGradient : null,
                    color: active ? null : AppColors.grey300,
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                if (_currentPage > 0)
                  IconButton(
                    onPressed: _previousPage,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.grey100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    icon: Icon(
                      LucideIcons.chevronLeft,
                      size: 22.sp,
                      color: AppColors.textPrimary,
                    ),
                  )
                else
                  SizedBox(width: 48.w),
                Expanded(
                  child: _PrimaryCtaButton(
                    label: _isLastPage ? 'Jelajahi Katalog' : 'Lanjut',
                    icon: _isLastPage
                        ? LucideIcons.layoutGrid
                        : LucideIcons.arrowRight,
                    onPressed: _nextPage,
                  ),
                ),
              ],
            ),
            if (_isLastPage) ...[
              SizedBox(height: 12.h),
              TextButton(
                onPressed: _goToLogin,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Sudah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else
              SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.content,
    required this.index,
    required this.textBottomPadding,
  });

  final OnboardingContent content;
  final int index;
  final double textBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _FullBleedHeroImage(content: content),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.35, 1.0],
                colors: [
                  Colors.transparent,
                  AppColors.black.withValues(alpha: 0.45),
                  AppColors.black.withValues(alpha: 0.82),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, textBottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StepChip(content: content, index: index),
                  SizedBox(height: 16.h),
                  Text(
                    content.title,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      height: 1.12,
                      letterSpacing: -0.8,
                      shadows: [
                        Shadow(
                          color: AppColors.black.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    content.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.white.withValues(alpha: 0.92),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FullBleedHeroImage extends StatelessWidget {
  const _FullBleedHeroImage({required this.content});

  final OnboardingContent content;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      content.imageAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.primaryDark,
        alignment: Alignment.center,
        child: Icon(
          content.icon,
          size: 88.sp,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.content, required this.index});

  final OnboardingContent content;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(content.icon, size: 14.sp, color: AppColors.white),
          SizedBox(width: 6.w),
          Text(
            content.stepLabel,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${index + 1}/4',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCtaButton extends StatelessWidget {
  const _PrimaryCtaButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(icon, color: Colors.white, size: 18.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingContent {
  const OnboardingContent({
    required this.stepLabel,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.icon,
    required this.accent,
  });

  final String stepLabel;
  final String title;
  final String description;
  final String imageAsset;
  final IconData icon;
  final Color accent;
}
