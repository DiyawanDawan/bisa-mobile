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

class _CategoryWithPath {
  final CategoryModel category;
  final List<String> path;

  _CategoryWithPath(this.category, this.path);
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
  void initState() {
    super.initState();
    // Default expand level 1 roots for Tokopedia-style multi-tree list
    for (final root in widget.roots) {
      _expandedIds.add(root.id);
    }
  }

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

  List<_CategoryWithPath> _getSearchResults(List<CategoryModel> roots, String query) {
    final results = <_CategoryWithPath>[];
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return results;

    void traverse(CategoryModel node, List<String> parentPath) {
      final currentPath = [...parentPath, node.name];
      final matches = node.name.toLowerCase().contains(q) ||
          (node.description ?? '').toLowerCase().contains(q);
      if (matches && node.children.isEmpty) {
        results.add(_CategoryWithPath(node, currentPath));
      }
      for (final child in node.children) {
        traverse(child, currentPath);
      }
    }

    for (final root in roots) {
      traverse(root, []);
    }
    return results;
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
    final isSearching = _query.trim().isNotEmpty;
    final searchResults = isSearching ? _getSearchResults(widget.roots, _query) : <_CategoryWithPath>[];

    return Padding(
      padding: sheetBottomPadding(context),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.85.sh),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.pill)),
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
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Flexible(
              child: isSearching
                  ? _buildSearchResults(searchResults)
                  : widget.roots.isEmpty
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
                      : _buildTreeList(widget.roots),
            ),
          ],
        ),
      ),
    );
  }

  /// Tokopedia-style Search Highlight View with Full Breadcrumb Path
  Widget _buildSearchResults(List<_CategoryWithPath> results) {
    if (results.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.searchX, size: 40.sp, color: AppColors.grey300),
            SizedBox(height: 8.h),
            Text(
              'marketplace.category_not_found'.tr(),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.grey100),
      itemBuilder: (context, index) {
        final item = results[index];
        final cat = item.category;
        final isSel = widget.selected?.id == cat.id;
        final breadcrumb = item.path.join(' > ');

        return ListTile(
          key: ValueKey(cat.id),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(LucideIcons.gitCommitHorizontal, size: 12.sp, color: AppColors.primary),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      breadcrumb,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              if (cat.description != null && cat.description!.isNotEmpty)
                Text(
                  cat.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          trailing: isSel
              ? Icon(LucideIcons.check, color: AppColors.primary, size: 20.sp)
              : Icon(LucideIcons.chevronRight, color: AppColors.grey300, size: 18.sp),
        );
      },
    );
  }

  /// Multi-Tree Navigation List
  Widget _buildTreeList(List<CategoryModel> nodes) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 24.h),
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
    final isLeaf = !hasChildren;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : depth == 1
                    ? AppColors.grey50.withValues(alpha: 0.5)
                    : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: isSelected
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
                : Border.all(color: AppColors.grey100),
          ),
          child: InkWell(
            onTap: () {
              if (hasChildren) {
                _toggleExpand(node.id);
              } else {
                Navigator.pop(context, node);
              }
            },
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w + (depth - 1) * 18.w,
                right: 12.w,
                top: 12.h,
                bottom: 12.h,
              ),
              child: Row(
                children: [
                  if (hasChildren)
                    GestureDetector(
                      onTap: () => _toggleExpand(node.id),
                      child: Container(
                        width: 26.w,
                        height: 26.w,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          isExpanded
                              ? LucideIcons.chevronDown
                              : LucideIcons.chevronRight,
                          size: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 26.w),

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
                            color: isLeaf ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                        if (node.description != null && node.description!.isNotEmpty)
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
                  if (isLeaf && isSelected)
                    Icon(LucideIcons.check, color: AppColors.primary, size: 20.sp)
                  else if (hasChildren)
                    Icon(
                      isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                      color: AppColors.grey300,
                      size: 16.sp,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          ...node.children.map((child) => _buildTreeNode(child)),
      ],
    );
  }
}

String placeholderHint(BuildContext context, {String? fallback}) {
  return fallback ?? 'marketplace.search_category_hint'.tr();
}
