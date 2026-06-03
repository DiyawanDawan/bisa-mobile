import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 5,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (_, __) => Bone(
                  width: 88.w,
                  height: 28.h,
                  borderRadius: BorderRadius.circular(20.r),
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
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
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
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.grey50,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.grey200,
                    ),
                  ),
                  child: Text(
                    isAll ? 'Semua Kategori' : category!.name,
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
