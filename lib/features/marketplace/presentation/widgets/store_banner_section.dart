import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_media_skeleton.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../data/models/store_banner_model.dart';
import '../bloc/store_banner_cubit.dart';
import '../../../../shared/widgets/bisa_dialog.dart';

Widget storeBannerNetworkImage(String url, {required double height, BoxFit fit = BoxFit.cover}) {
  return BisaNetworkImage(
    imageUrl: url,
    fit: fit,
    width: double.infinity,
    height: height,
    errorWidget: (_, __, ___) => Container(
      height: height,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Icon(
          LucideIcons.imageOff,
          color: AppColors.white.withValues(alpha: 0.5),
          size: 36.sp,
        ),
      ),
    ),
  );
}

/// Kelola banyak banner toko (carousel + unggah/hapus).
class StoreBannerSection extends StatefulWidget {
  const StoreBannerSection({
    super.key,
    this.editable = true,
    this.compact = false,
  });

  final bool editable;
  final bool compact;

  @override
  State<StoreBannerSection> createState() => _StoreBannerSectionState();
}

class _StoreBannerSectionState extends State<StoreBannerSection> {
  final _picker = ImagePicker();
  final _pageController = PageController();
  int _currentPage = 0;
  bool _uploading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    if (!widget.editable || _uploading) return;
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;

    setState(() => _uploading = true);
    await context.read<StoreBannerCubit>().uploadBanner(file.path);
    if (mounted) setState(() => _uploading = false);
  }

  Future<void> _deleteCurrent(List<StoreBannerModel> banners) async {
    if (banners.isEmpty || _currentPage >= banners.length) return;
    final banner = banners[_currentPage];

    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'marketplace.store_banner_delete_title'.tr(),
      message: 'marketplace.store_banner_delete_body'.tr(),
      confirmText: 'hapus'.tr(),
      destructive: true,
    );
    if (confirmed != true || !mounted) return;

    await context.read<StoreBannerCubit>().deleteBanner(banner.id);
    if (mounted && _currentPage > 0) {
      setState(() => _currentPage = _currentPage - 1);
      _pageController.jumpToPage(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 120.h : 150.h;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.xs),
      child: BlocBuilder<StoreBannerCubit, StoreBannerState>(
        builder: (context, state) {
          final banners = state.maybeWhen(
            loaded: (List<StoreBannerModel> items) => widget.editable
                ? items
                : items.where((b) => b.isActive).toList(),
            orElse: () => <StoreBannerModel>[],
          );
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'marketplace.store_banner_title'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (widget.editable)
                    Text(
                      '${banners.length}/10',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isLoading && banners.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.white),
                        ),
                      )
                    else if (banners.isEmpty)
                      _EmptyBannerSlot(
                        editable: widget.editable,
                        onTap: _pickAndUpload,
                      )
                    else
                      PageView.builder(
                        controller: _pageController,
                        itemCount: banners.length,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (_, index) {
                          return storeBannerNetworkImage(
                            banners[index].imageUrl,
                            height: height,
                          );
                        },
                      ),
                    if (banners.isNotEmpty)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.transparent,
                              AppColors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    if (banners.length > 1)
                      Positioned(
                        bottom: 10.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            banners.length,
                            (i) => Container(
                              width: _currentPage == i ? 16.w : 6.w,
                              height: 6.h,
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                color: _currentPage == i
                                    ? AppColors.white
                                    : AppColors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (widget.editable) _buildActions(banners),
                    if (_uploading || (isLoading && banners.isNotEmpty))
                      Container(
                        color: AppColors.black.withValues(alpha: 0.35),
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.white),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.editable) ...[
                SizedBox(height: AppSpacing.sm),
                Text(
                  'marketplace.store_banner_upload_hint'.tr(),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
                if (banners.length > 1) ...[
                  SizedBox(height: AppSpacing.sm10),
                  SizedBox(
                    height: 52.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: banners.length,
                      separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        final selected = index == _currentPage;
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                          child: Container(
                            width: 72.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.grey200,
                                width: selected ? 2 : 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: storeBannerNetworkImage(
                              banner.imageUrl,
                              height: 52.h,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildActions(List<StoreBannerModel> banners) {
    return Positioned(
      right: 10.w,
      bottom: 10.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (banners.isNotEmpty)
            _OverlayButton(
              icon: LucideIcons.trash2,
              label: 'hapus'.tr(),
              onTap: () => _deleteCurrent(banners),
              color: AppColors.error,
            ),
          if (banners.isNotEmpty) SizedBox(width: AppSpacing.sm),
          if (banners.length < 10)
            _OverlayButton(
              icon: LucideIcons.plus,
              label: banners.isEmpty
                  ? 'marketplace.store_banner_upload'.tr()
                  : 'marketplace.store_banner_add'.tr(),
              onTap: _pickAndUpload,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}

class _EmptyBannerSlot extends StatelessWidget {
  const _EmptyBannerSlot({required this.editable, required this.onTap});

  final bool editable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: editable ? onTap : null,
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.images,
                  color: AppColors.white.withValues(alpha: 0.9),
                  size: 28.sp,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  editable
                      ? 'marketplace.store_banner_tap_upload'.tr()
                      : 'marketplace.store_banner_empty'.tr(),
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.95),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
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

class _OverlayButton extends StatelessWidget {
  const _OverlayButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: color),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carousel read-only untuk profil supplier publik.
class StoreBannerCarousel extends StatelessWidget {
  const StoreBannerCarousel({super.key, this.height});

  final double? height;

  Widget _placeholder(double h, {String? message, VoidCallback? onRetry}) {
    return Container(
      height: h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.store,
              color: AppColors.white.withValues(alpha: 0.35),
              size: 48.sp,
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.sm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.sm10),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textOnPrimary,
                  backgroundColor: AppColors.surface.withValues(alpha: 0.15),
                ),
                child: Text(
                  'orders.reload'.tr(),
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = height ?? 160.h;

    return BlocBuilder<StoreBannerCubit, StoreBannerState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24.r),
          ),
          child: state.maybeWhen(
            loaded: (List<StoreBannerModel> banners) {
              final active = banners.where((b) => b.isActive).toList();
              if (active.isEmpty) {
                return _placeholder(
                  h,
                  message: 'marketplace.store_banner_supplier_empty'.tr(),
                );
              }
              if (active.length == 1) {
                return storeBannerNetworkImage(active.first.imageUrl, height: h);
              }
              return SizedBox(
                height: h,
                child: PageView.builder(
                  itemCount: active.length,
                  itemBuilder: (_, i) =>
                      storeBannerNetworkImage(active[i].imageUrl, height: h),
                ),
              );
            },
            loading: () => BisaMediaSkeleton(
              width: double.infinity,
              height: h,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.r),
              ),
            ),
            error: (_) => _placeholder(
              h,
              message: 'marketplace.store_banner_load_error'.tr(),
              onRetry: () => context.read<StoreBannerCubit>().retryLastUserBanners(),
            ),
            orElse: () => _placeholder(h),
          ),
        );
      },
    );
  }
}
