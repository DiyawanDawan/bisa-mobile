import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';

class MarketplaceBanner extends StatefulWidget {
  final String productMode;
  const MarketplaceBanner({super.key, required this.productMode});

  @override
  State<MarketplaceBanner> createState() => _MarketplaceBannerState();
}

class _MarketplaceBannerState extends State<MarketplaceBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _bannerImages.length,
            itemBuilder: (context, index) {
              if (widget.productMode == 'ORGANIC_PRODUCE') {
                return _buildBannerItem(
                  _bannerImages[index],
                  index == 0
                      ? 'marketplace.banner_organic_tag1'.tr()
                      : 'marketplace.banner_organic_tag2'.tr(),
                  index == 0
                      ? 'marketplace.banner_organic_title1'.tr()
                      : 'marketplace.banner_organic_title2'.tr(),
                );
              }
              return _buildBannerItem(
                _bannerImages[index],
                index == 0
                    ? 'marketplace.banner_biomass_tag1'.tr()
                    : 'marketplace.banner_biomass_tag2'.tr(),
                index == 0
                    ? 'marketplace.banner_biomass_title1'.tr()
                    : 'marketplace.banner_biomass_title2'.tr(),
              );
            },
          ),
          Positioned(
            bottom: AppSpacing.md12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerImages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentPage == index ? 24.w : 8.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(String assetPath, String tag, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              assetPath,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    AppColors.black.withOpacity(0.7),
                    AppColors.black.withOpacity(0.2),
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSpacing.sm10, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
