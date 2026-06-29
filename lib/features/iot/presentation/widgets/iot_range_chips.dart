import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';

class IotRangeChips extends StatelessWidget {
  const IotRangeChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static const options = [
    ('1h', '1 jam'),
    ('24h', '24 jam'),
    ('7d', '7 hari'),
    ('30d', '30 hari'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((opt) {
        final isSel = selected == opt.$1;
        return ChoiceChip(
          label: Text(
            opt.$2,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isSel ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          selected: isSel,
          onSelected: (_) => onSelected(opt.$1),
          selectedColor: AppColors.primaryLight.withValues(alpha: 0.6),
          backgroundColor: AppColors.grey50,
          side: BorderSide(
            color: isSel ? AppColors.primary : AppColors.grey200,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
        );
      }).toList(),
    );
  }
}
