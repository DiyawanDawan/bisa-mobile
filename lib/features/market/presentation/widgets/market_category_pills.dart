import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_spacing.dart';
import 'package:mobile_bisa/shared/widgets/bisa_filter_chip.dart';

class MarketCategoryPills extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  const MarketCategoryPills({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          BisaFilterChip(
            label: 'market.filter_all'.tr(),
            isSelected: selectedCategory == null,
            onTap: () => onSelected(null),
          ),
          SizedBox(width: AppSpacing.sm),
          ...categories.map(
            (cat) => Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: BisaFilterChip(
                label: cat,
                isSelected: selectedCategory == cat,
                onTap: () => onSelected(cat),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
