import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/category_model.dart';

typedef SupplierProductFilterApply = void Function({
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
      backgroundColor: Colors.transparent,
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

class _SupplierProductFilterSheetState extends State<SupplierProductFilterSheet> {
  late String? _status;
  late String? _categoryId;
  late String _sortKey;

  static const _statusOptions = <String?, String>{
    null: 'Semua Status',
    'ACTIVE': 'Aktif',
    'DRAFT': 'Draft',
    'OUT_OF_STOCK': 'Stok Habis',
    'INACTIVE': 'Non-aktif',
  };

  static const _sortOptions = <String, String>{
    'newest': 'Terbaru',
    'priceAsc': 'Harga Terendah',
    'priceDesc': 'Harga Tertinggi',
    'sold': 'Terlaris',
  };

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
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h + bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(LucideIcons.listFilter, size: 22.sp, color: AppColors.primary),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Filter Produk',
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
                  'Reset',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(LucideIcons.x, color: AppColors.grey500, size: 22.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Status Produk'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _statusOptions.entries.map((entry) {
                      return _filterChip(
                        entry.value,
                        _status == entry.key,
                        () => setState(() => _status = entry.key),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  _sectionTitle('Kategori'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      _filterChip(
                        'Semua Kategori',
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
                  SizedBox(height: 24.h),
                  _sectionTitle('Urutkan'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _sortOptions.entries.map((entry) {
                      return _filterChip(
                        entry.value,
                        _sortKey == entry.key,
                        () => setState(() => _sortKey = entry.key),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
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
                'Terapkan Filter',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.grey50,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey200,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
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
({String? sortBy, String? sortOrder}) resolveSupplierProductSort(String sortKey) {
  switch (sortKey) {
    case 'priceAsc':
      return (sortBy: 'pricePerUnit', sortOrder: 'asc');
    case 'priceDesc':
      return (sortBy: 'pricePerUnit', sortOrder: 'desc');
    case 'sold':
      return (sortBy: 'averageRating', sortOrder: 'desc');
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
