import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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

  @override
  Widget build(BuildContext context) {
    final bool hasUser = userName != null;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (!hasUser) ...[
                BisaLogo(size: 36.w),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasUser)
                      Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      hasUser ? userName! : 'Marketplace',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (!hasUser) ...[
                _buildLoginCTA(context),
              ] else
                _buildActionIcons(context),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildLoginCTA(BuildContext context) {
    return TextButton(
      onPressed: () => AuthSheet.show(context),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      child: Text(
        'Masuk',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
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
              SizedBox(width: 8.w),
              _iconBtn(
                LucideIcons.heart,
                () => context.push('/wishlist'),
              ),
              SizedBox(width: 8.w),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _iconBtn(LucideIcons.shoppingCart, () => context.push('/cart')),
                  if (commerce.cartCount > 0)
                    Positioned(
                      right: 4.w,
                      top: 4.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${commerce.cartCount}',
                          style: TextStyle(
                            color: Colors.white,
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

  Widget _buildSearchBar() {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearchSubmitted,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: productMode == 'ORGANIC_PRODUCE'
              ? 'Cari hasil tani organik...'
              : 'Cari produk biomass...',
          hintStyle: TextStyle(
            color: AppColors.textHint,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 20.sp,
            color: AppColors.textSecondary,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 32.w,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}
