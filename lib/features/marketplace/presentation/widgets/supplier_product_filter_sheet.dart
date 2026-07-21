import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../data/models/category_model.dart';

typedef SupplierProductFilterApply =
    void Function({
      required String? status,
      required String? categoryId,
      required String sortKey,
    });

class SupplierProductFilterSheet extends StatefulWidget {
  const SupplierProductFilterSheet({
    super.key,
    required this.initialStatus,
    required this.initialCategoryId,
    required this.initialSortKey,
    required this.categories,
    required this.onApply,
  });

  final String? initialStatus;
  final String? initialCategoryId;
  final String initialSortKey;
  final List<CategoryModel> categories;
  final SupplierProductFilterApply onApply;

  static void show(
    BuildContext context, {
    required String? status,
    required String? categoryId,
    required String sortKey,
    required List<CategoryModel> categories,
    required SupplierProductFilterApply onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => SupplierProductFilterSheet(
        initialStatus: status,
        initialCategoryId: categoryId,
        initialSortKey: sortKey,
        categories: categories,
        onApply: onApply,
      ),
    );
  }

  @override
  State<SupplierProductFilterSheet> createState() =>
      _SupplierProductFilterSheetState();
}

class _SupplierProductFilterSheetState
    extends State<SupplierProductFilterSheet> {
  late String? _status;
  late String? _categoryId;
  late String _sortKey;

  List<MapEntry<String?, String>> get _statusOptions => [
    MapEntry(null, 'marketplace.status_all'.tr()),
    MapEntry('ACTIVE', 'marketplace.status_active'.tr()),
    MapEntry('DRAFT', 'marketplace.status_draft'.tr()),
    MapEntry('OUT_OF_STOCK', 'marketplace.status_out_of_stock'.tr()),
    MapEntry('INACTIVE', 'marketplace.status_inactive'.tr()),
  ];

  List<MapEntry<String, String>> get _sortOptions => [
    MapEntry('newest', 'marketplace.sort_newest'.tr()),
    MapEntry('priceAsc', 'marketplace.sort_price_low'.tr()),
    MapEntry('priceDesc', 'marketplace.sort_price_high'.tr()),
    MapEntry('sold', 'marketplace.sort_bestseller'.tr()),
  ];

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _categoryId = widget.initialCategoryId;
    _sortKey = widget.initialSortKey;
  }

  void _reset() {
    setState(() {
      _status = null;
      _categoryId = null;
      _sortKey = 'newest';
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      padding: bisaSheetPadding(context),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxlPx.r),
        ),
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
          SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: [
              Icon(
                LucideIcons.listFilter,
                size: 22.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Text(
                  'marketplace.supplier_filter_title'.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: _reset,
                child: Text(
                  'reset'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  LucideIcons.x,
                  color: AppColors.grey500,
                  size: 22.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('marketplace.filter_section_status'.tr()),
                  SizedBox(height: AppSpacing.md12),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _statusOptions.map((entry) {
                      return _filterChip(
                        entry.value,
                        _status == entry.key,
                        () => setState(() => _status = entry.key),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppSpacing.sectionGap),
                  _sectionTitle('marketplace.filter_section_category'.tr()),
                  SizedBox(height: AppSpacing.md12),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      _filterChip(
                        'marketplace.category_all_products'.tr(),
                        _categoryId == null,
                        () => setState(() => _categoryId = null),
                      ),
                      ...widget.categories.map(
                        (cat) => _filterChip(
                          cat.name,
                          _categoryId == cat.id,
                          () => setState(() => _categoryId = cat.id),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sectionGap),
                  _sectionTitle('marketplace.filter_section_sort'.tr()),
                  SizedBox(height: AppSpacing.md12),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _sortOptions.map((entry) {
                      return _filterChip(
                        entry.value,
                        _sortKey == entry.key,
                        () => setState(() => _sortKey = entry.key),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppSpacing.sectionGap),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
              onPressed: () {
                widget.onApply(
                  status: _status,
                  categoryId: _categoryId,
                  sortKey: _sortKey,
                );
                Navigator.pop(context);
              },
              child: Text(
                'marketplace.apply_filter'.tr(),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.grey50,
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
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}

/// Konversi sortKey ke parameter API.
({String? sortBy, String? sortOrder}) resolveSupplierProductSort(
  String sortKey,
) {
  switch (sortKey) {
    case 'priceAsc':
      return (sortBy: 'pricePerUnit', sortOrder: 'asc');
    case 'priceDesc':
      return (sortBy: 'pricePerUnit', sortOrder: 'desc');
    case 'sold':
      return (sortBy: 'totalSold', sortOrder: 'desc');
    case 'newest':
    default:
      return (sortBy: 'createdAt', sortOrder: 'desc');
  }
}

int countActiveSupplierProductFilters({
  String? status,
  String? categoryId,
  String sortKey = 'newest',
}) {
  var count = 0;
  if (status != null) count++;
  if (categoryId != null) count++;
  if (sortKey != 'newest') count++;
  return count;
}
