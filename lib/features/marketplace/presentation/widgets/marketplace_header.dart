import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
import '../../../../shared/widgets/notification_bell_button.dart';

class MarketplaceHeader extends StatelessWidget {
  final String? userName;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onFilterTapped;
  final String productMode;

  const MarketplaceHeader({
    super.key,
    required this.userName,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onFilterTapped,
    this.productMode = 'BIOMASS_MATERIAL',
  });

  static const double _guestBarHeight = 44;

  @override
  Widget build(BuildContext context) {
    final bool hasUser = userName != null;
    final guestBarHeight = _guestBarHeight.h;
    final statusBarInset = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        statusBarInset + AppSpacing.compact,
        AppSpacing.pageGutter,
        AppSpacing.comfortable,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!hasUser)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BisaLogo(size: guestBarHeight - 4.h),
                SizedBox(width: AppSpacing.sm10),
                Expanded(
                  child: _buildSearchBar(height: guestBarHeight, compact: true),
                ),
                SizedBox(width: AppSpacing.sm10),
                _buildLoginCTA(context, height: guestBarHeight),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildSearchBar(height: guestBarHeight, compact: true),
                ),
                SizedBox(width: AppSpacing.sm10),
                _buildActionIcons(context),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLoginCTA(BuildContext context, {required double height}) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: () => AuthSheet.show(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          minimumSize: Size(0, height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        child: Text(
          'login'.tr(),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    final isBuyer = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u.role == 'BUYER',
      orElse: () => false,
    );

    return BlocBuilder<CommerceCubit, CommerceState>(
      builder: (context, commerce) {
        return Row(
          children: [
            const NotificationBellButton(useAppBarStyle: false),
            if (isBuyer) ...[
              SizedBox(width: AppSpacing.sm),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _iconBtn(
                    LucideIcons.shoppingCart,
                    () => context.push('/cart'),
                  ),
                  if (commerce.cartCount > 0)
                    Positioned(
                      right: 4.w,
                      top: 4.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${commerce.cartCount}',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey50,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimary, size: 20.sp),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildSearchBar({bool compact = false, double? height}) {
    final fieldHeight = height ?? (compact ? 44.h : 52.h);
    final radius = AppRadius.lg;
    final hint = productMode == 'ORGANIC_PRODUCE'
        ? 'marketplace.search_organic'.tr()
        : 'marketplace.search_biochar'.tr();

    return SizedBox(
      height: fieldHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.grey100, width: 1.5),
          boxShadow: compact
              ? null
              : [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.sm10 : AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.search,
                size: compact ? 18.sp : 20.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: compact ? 6.w : 8.w),
              Expanded(
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: onSearchSubmitted,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: compact ? 12.sp : 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
