import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../data/models/category_model.dart';

const _kMaxTreeDepth = 3;

Future<CategoryModel?> showCategoryTreePicker({
  required BuildContext context,
  required List<CategoryModel> roots,
  CategoryModel? selected,
  required String title,
  String searchHint = '',
}) {
  return showModalBottomSheet<CategoryModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (ctx) => _CategoryTreeSheet(
      roots: roots,
      selected: selected,
      title: title,
      searchHint: searchHint,
    ),
  );
}

class _CategoryTreeSheet extends StatefulWidget {
  const _CategoryTreeSheet({
    required this.roots,
    required this.title,
    required this.searchHint,
    this.selected,
  });

  final List<CategoryModel> roots;
  final CategoryModel? selected;
  final String title;
  final String searchHint;

  @override
  State<_CategoryTreeSheet> createState() => _CategoryTreeSheetState();
}

class _CategoryTreeSheetState extends State<_CategoryTreeSheet> {
  final Set<String> _expandedIds = {};
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  List<CategoryModel> _searchRecursive(
    List<CategoryModel> nodes,
    String query,
  ) {
    final result = <CategoryModel>[];
    final q = query.toLowerCase();
    for (final node in nodes) {
      final matches = node.name.toLowerCase().contains(q) ||
          (node.description ?? '').toLowerCase().contains(q);
      final childMatches = _searchRecursive(node.children, query);
      if (matches || childMatches.isNotEmpty) {
        result.add(node.copyWith(children: childMatches));
      }
    }
    return result;
  }

  List<CategoryModel> get _filteredRoots {
    final q = _query.trim();
    if (q.isEmpty) return widget.roots;
    return _searchRecursive(widget.roots, q);
  }

  int _indentFor(CategoryModel node) {
    int depth = 1;
    if (node.parentId != null) depth = 2;
    if (node.parentId != null) {
      final grandParent = _findParent(node.parentId!);
      if (grandParent?.parentId != null) depth = 3;
    }
    return depth;
  }

  CategoryModel? _findParent(String parentId) {
    for (final root in widget.roots) {
      final found = _findInTree(root, parentId);
      if (found != null) return found;
    }
    return null;
  }

  CategoryModel? _findInTree(CategoryModel node, String id) {
    if (node.id == id) return node;
    for (final child in node.children) {
      final found = _findInTree(child, id);
      if (found != null) return found;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final displayRoots = _filteredRoots;

    return Padding(
      padding: sheetBottomPadding(context),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.8.sh),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.pill)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSpacing.sm10),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
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
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: widget.searchHint.isNotEmpty
                      ? widget.searchHint
                      : 'marketplace.search_category_hint'.tr(),
                  prefixIcon: Icon(LucideIcons.search, size: 18.sp),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(LucideIcons.xCircle, size: 16.sp),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.grey50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: AppSpacing.md12),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Flexible(
              child: displayRoots.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(AppSpacing.xxl),
                      child: Text(
                        'marketplace.category_not_found'.tr(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : _buildTreeList(displayRoots),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeList(List<CategoryModel> nodes) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 24.h),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return _buildTreeNode(nodes[index]);
      },
    );
  }

  Widget _buildTreeNode(CategoryModel node) {
    final depth = _indentFor(node);
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = _expandedIds.contains(node.id);
    final isSelected = widget.selected?.id == node.id;
    final canExpand = hasChildren && depth < _kMaxTreeDepth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color:
              isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: () => Navigator.pop(context, node),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: EdgeInsets.only(
                left: 8.w + (depth - 1) * 20.w,
                right: 8.w,
                top: 12.h,
                bottom: 12.h,
              ),
              child: Row(
                children: [
                  if (canExpand)
                    GestureDetector(
                      onTap: () => _toggleExpand(node.id),
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        alignment: Alignment.center,
                        child: Icon(
                          isExpanded
                              ? LucideIcons.chevronDown
                              : LucideIcons.chevronRight,
                          size: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else if (depth < _kMaxTreeDepth)
                    SizedBox(width: 24.w),
                  Icon(
                    depth == 1
                        ? LucideIcons.folderOpen
                        : depth == 2
                            ? LucideIcons.folder
                            : LucideIcons.tag,
                    size: 18.sp,
                    color: isSelected
                        ? AppColors.primary
                        : depth == 1
                            ? AppColors.primary
                            : AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          node.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : depth == 1
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                            fontSize: depth == 1 ? 14.sp : 13.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (node.description != null &&
                            node.description!.isNotEmpty)
                          Text(
                            node.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: depth == 1
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : depth == 2
                              ? Colors.blue.withValues(alpha: 0.1)
                              : AppColors.grey100,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      depth == 1
                          ? 'L1'
                          : depth == 2
                              ? 'L2'
                              : 'L3',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: depth == 1
                            ? AppColors.primary
                            : depth == 2
                                ? Colors.blue
                                : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  if (isSelected)
                    Icon(LucideIcons.check,
                        color: AppColors.primary, size: 20.sp),
                ],
              ),
            ),
          ),
        ),
        if (canExpand && isExpanded)
          ...node.children.map((child) => _buildTreeNode(child)),
        if (depth < _kMaxTreeDepth)
          SizedBox(height: 1.h),
      ],
    );
  }
}

/// Returns a search hint or empty.
String placeholderHint(BuildContext context, {String? fallback}) {
  return fallback ?? 'marketplace.search_category_hint'.tr();
}
