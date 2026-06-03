import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

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
      backgroundColor: Colors.transparent,
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
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
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
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Pencarian',
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
          SizedBox(height: 12.h),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Urutkan Berdasarkan',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _buildFilterChip(
                        'Terbaru',
                        _tempSortBy == 'createdAt',
                        () => setState(() => _tempSortBy = 'createdAt'),
                      ),
                      SizedBox(width: 12.w),
                      _buildFilterChip(
                        'Harga Terendah',
                        _tempSortBy == 'priceAsc',
                        () => setState(() => _tempSortBy = 'priceAsc'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _buildFilterChip(
                        'Harga Tertinggi',
                        _tempSortBy == 'priceDesc',
                        () => setState(() => _tempSortBy = 'priceDesc'),
                      ),
                      SizedBox(width: 12.w),
                      _buildFilterChip(
                        'Terlaris',
                        _tempSortBy == 'sold',
                        () => setState(() => _tempSortBy = 'sold'),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Tipe Produk',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      _buildFilterChip(
                        'Semua',
                        _tempCategory == 'Semua',
                        () => setState(() => _tempCategory = 'Semua'),
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
                  SizedBox(height: 32.h),
                  Text(
                    'Rating Minimum',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.grey200,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withOpacity(0.1),
                      valueIndicatorColor: AppColors.primary,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: _tempMinRating ?? 0,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _tempMinRating?.toStringAsFixed(1) ?? 'Semua',
                      onChanged: (val) {
                        setState(() => _tempMinRating = val == 0 ? null : val);
                      },
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Rentang Harga',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPriceInput('Min', _minPriceController),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildPriceInput('Max', _maxPriceController),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
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
                'Terapkan Filter',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey200,
            ),
            borderRadius: BorderRadius.circular(20.r),
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
        borderRadius: BorderRadius.circular(12.r),
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
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
