import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/category_model.dart';

/// Searchable category picker — used after product mode / biomassa type is chosen.
Future<CategoryModel?> showCategorySearchPicker({
  required BuildContext context,
  required List<CategoryModel> categories,
  CategoryModel? selected,
  required String title,
  String searchHint = 'Cari kategori...',
}) {
  return showModalBottomSheet<CategoryModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _CategorySearchSheet(
      categories: categories,
      selected: selected,
      title: title,
      searchHint: searchHint,
    ),
  );
}

class CategoryPickerField extends StatelessWidget {
  const CategoryPickerField({
    super.key,
    required this.label,
    required this.enabled,
    required this.isLoading,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    this.disabledHint = 'Pilih jenis biomassa terlebih dahulu',
    this.emptyHint = 'Tidak ada kategori',
    this.pickerTitle = 'Pilih Kategori',
    this.searchHint = 'Cari kategori...',
  });

  final String label;
  final bool enabled;
  final bool isLoading;
  final List<CategoryModel> categories;
  final String? selectedId;
  final ValueChanged<CategoryModel?> onSelected;
  final String disabledHint;
  final String emptyHint;
  final String pickerTitle;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    CategoryModel? selected;
    if (selectedId != null) {
      for (final c in categories) {
        if (c.id == selectedId) {
          selected = c;
          break;
        }
      }
    }

    final hint = !enabled
        ? disabledHint
        : isLoading
            ? 'Memuat kategori...'
            : categories.isEmpty
                ? emptyHint
                : 'Pilih kategori';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Material(
          color: enabled ? AppColors.white : AppColors.grey50,
          borderRadius: BorderRadius.circular(8.r),
          child: InkWell(
            onTap: enabled && !isLoading && categories.isNotEmpty
                ? () async {
                    final picked = await showCategorySearchPicker(
                      context: context,
                      categories: categories,
                      selected: selected,
                      title: pickerTitle,
                      searchHint: searchHint,
                    );
                    if (picked != null) onSelected(picked);
                  }
                : null,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: enabled ? AppColors.grey300 : AppColors.grey200,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.layoutGrid,
                    size: 18.sp,
                    color: enabled ? AppColors.primary : AppColors.grey300,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      selected?.name ?? hint,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: selected != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight:
                            selected != null ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  Icon(
                    LucideIcons.search,
                    size: 16.sp,
                    color: enabled ? AppColors.textSecondary : AppColors.grey300,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategorySearchSheet extends StatefulWidget {
  const _CategorySearchSheet({
    required this.categories,
    required this.title,
    required this.searchHint,
    this.selected,
  });

  final List<CategoryModel> categories;
  final CategoryModel? selected;
  final String title;
  final String searchHint;

  @override
  State<_CategorySearchSheet> createState() => _CategorySearchSheetState();
}

class _CategorySearchSheetState extends State<_CategorySearchSheet> {
  late List<CategoryModel> _filtered;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.categories;
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = widget.categories;
        return;
      }
      _filtered = widget.categories.where((c) {
        final name = c.name.toLowerCase();
        final desc = (c.description ?? '').toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.75.sh),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(LucideIcons.x, size: 20.sp),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: Icon(LucideIcons.search, size: 18.sp),
                  filled: true,
                  fillColor: AppColors.grey50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: _filtered.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Text(
                        'Kategori tidak ditemukan',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 24.h),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.grey100),
                      itemBuilder: (context, index) {
                        final cat = _filtered[index];
                        final isSel = widget.selected?.id == cat.id;
                        return ListTile(
                          key: ValueKey(cat.id),
                          onTap: () => Navigator.pop(context, cat),
                          leading: CircleAvatar(
                            backgroundColor: isSel
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : AppColors.grey50,
                            child: Icon(
                              LucideIcons.tag,
                              size: 18.sp,
                              color: isSel ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                          title: Text(
                            cat.name,
                            style: TextStyle(
                              fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: cat.description != null && cat.description!.isNotEmpty
                              ? Text(
                                  cat.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : null,
                          trailing: isSel
                              ? Icon(LucideIcons.check, color: AppColors.primary, size: 20.sp)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Human-readable labels for biomassa type enum values.
const Map<String, String> kBiomassaTypeLabels = {
  'BIOCHAR': 'Biochar',
  'SEKAM_PADI': 'Sekam Padi',
  'TONGKOL_JAGUNG': 'Tongkol Jagung',
  'TEMPURUNG_KELAPA': 'Tempurung Kelapa',
  'WOOD_CHIP': 'Wood Chip',
  'OTHER': 'Lainnya',
};

String biomassaTypeLabel(String value) =>
    kBiomassaTypeLabels[value] ?? value.replaceAll('_', ' ');

const List<String> kBiomassaTypeValues = [
  'BIOCHAR',
  'SEKAM_PADI',
  'TONGKOL_JAGUNG',
  'TEMPURUNG_KELAPA',
  'WOOD_CHIP',
  'OTHER',
];
