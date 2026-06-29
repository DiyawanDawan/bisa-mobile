import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/category_model.dart';
import '../bloc/category_cubit.dart';
import '../bloc/category_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Bar filter kategori horizontal untuk daftar produk supplier.
class SupplierProductCategoryBar extends StatelessWidget {
  const SupplierProductCategoryBar({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final String? selectedCategoryId;
  final ValueChanged<CategoryModel?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categories =
            state is CategoryLoaded ? state.categories : <CategoryModel>[];

        if (state is CategoryLoading && categories.isEmpty) {
          return SizedBox(
            height: 36.h,
            child: ShimmerLoading(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: 5,
                separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, __) => Bone(
                  width: 88.w,
                  height: 28.h,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          );
        }

        if (categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 38.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final category = isAll ? null : categories[index - 1];
              final isSelected = isAll
                  ? selectedCategoryId == null
                  : selectedCategoryId == category?.id;

              return GestureDetector(
                onTap: () => onCategorySelected(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.section),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.grey50,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.grey200,
                    ),
                  ),
                  child: Text(
                    isAll
                        ? 'marketplace.category_all_products'.tr()
                        : category!.name,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
