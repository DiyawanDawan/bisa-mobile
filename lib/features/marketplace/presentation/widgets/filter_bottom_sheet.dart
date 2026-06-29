import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../marketplace_i18n.dart';

class FilterBottomSheet extends StatefulWidget {
  final String initialSortBy;
  final String initialCategory;
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final double? initialMinRating;
  final List<String> categories;
  final Function(
    String sortBy,
    String category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  )
  onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialSortBy,
    required this.initialCategory,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialMinRating,
    required this.categories,
    required this.onApply,
  });

  static void show(
    BuildContext context, {
    required String sortBy,
    required String category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    required List<String> categories,
    required Function(String, String, double?, double?, double?) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => FilterBottomSheet(
        initialSortBy: sortBy,
        initialCategory: category,
        initialMinPrice: minPrice,
        initialMaxPrice: maxPrice,
        initialMinRating: minRating,
        categories: categories,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _tempSortBy;
  late String _tempCategory;
  late double? _tempMinRating;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _tempSortBy = widget.initialSortBy;
    _tempCategory = widget.initialCategory;
    _tempMinRating = widget.initialMinRating;
    _minPriceController = TextEditingController(
      text: widget.initialMinPrice?.toInt().toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialMaxPrice?.toInt().toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h + bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xxlPx.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'marketplace.filter_title'.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(LucideIcons.x, color: AppColors.grey500),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'marketplace.sort_by'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _buildFilterChip(
                        'marketplace.sort_newest'.tr(),
                        _tempSortBy == 'createdAt',
                        () => setState(() => _tempSortBy = 'createdAt'),
                      ),
                      SizedBox(width: AppSpacing.md12),
                      _buildFilterChip(
                        'marketplace.sort_price_low'.tr(),
                        _tempSortBy == 'priceAsc',
                        () => setState(() => _tempSortBy = 'priceAsc'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md12),
                  Row(
                    children: [
                      _buildFilterChip(
                        'marketplace.sort_price_high'.tr(),
                        _tempSortBy == 'priceDesc',
                        () => setState(() => _tempSortBy = 'priceDesc'),
                      ),
                      SizedBox(width: AppSpacing.md12),
                      _buildFilterChip(
                        'marketplace.sort_bestseller'.tr(),
                        _tempSortBy == 'sold',
                        () => setState(() => _tempSortBy = 'sold'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Text(
                    'marketplace.product_type'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md12,
                    runSpacing: AppSpacing.md12,
                    children: [
                      _buildFilterChip(
                        'marketplace.category_all'.tr(),
                        _tempCategory == kMarketplaceFilterAllCategory,
                        () => setState(
                          () => _tempCategory = kMarketplaceFilterAllCategory,
                        ),
                      ),
                      ...widget.categories.map(
                        (category) => _buildFilterChip(
                          category,
                          _tempCategory == category,
                          () => setState(() => _tempCategory = category),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Text(
                    'marketplace.min_rating'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.grey200,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withOpacity(0.1),
                      valueIndicatorColor: AppColors.primary,
                      valueIndicatorTextStyle: const TextStyle(
                        color: AppColors.surface,
                      ),
                    ),
                    child: Slider(
                      value: _tempMinRating ?? 0,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _tempMinRating?.toStringAsFixed(1) ??
                          'marketplace.category_all'.tr(),
                      onChanged: (val) {
                        setState(() => _tempMinRating = val == 0 ? null : val);
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Text(
                    'marketplace.price_range'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPriceInput(
                          'marketplace.price_min'.tr(),
                          _minPriceController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildPriceInput(
                          'marketplace.price_max'.tr(),
                          _maxPriceController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
              onPressed: () {
                widget.onApply(
                  _tempSortBy,
                  _tempCategory,
                  double.tryParse(_minPriceController.text),
                  double.tryParse(_maxPriceController.text),
                  _tempMinRating,
                );
                Navigator.pop(context);
              },
              child: Text(
                'marketplace.apply_filter'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey200,
            ),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primaryDark
                  : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput(String hint, TextEditingController controller) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
          prefixText: 'Rp ',
          prefixStyle: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
                    vertical: AppSpacing.md12,
          ),
        ),
      ),
    );
  }
}
