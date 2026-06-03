import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_media_skeleton.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../domain/entities/product_image_draft.dart';

/// Reorderable product image picker — add, delete, replace, drag to reorder.
class ProductImageEditor extends StatefulWidget {
  final List<ProductImageDraft> initialImages;
  final int maxImages;
  final ValueChanged<List<ProductImageDraft>>? onChanged;
  final bool showHint;

  const ProductImageEditor({
    super.key,
    this.initialImages = const [],
    this.maxImages = 5,
    this.onChanged,
    this.showHint = true,
  });

  @override
  State<ProductImageEditor> createState() => ProductImageEditorState();
}

class ProductImageEditorState extends State<ProductImageEditor> {
  late List<ProductImageDraft> _items;
  final _picker = ImagePicker();

  List<ProductImageDraft> get items => List.unmodifiable(_items);

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialImages);
  }

  @override
  void didUpdateWidget(ProductImageEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldSig = oldWidget.initialImages.map((d) => d.stableKey).join('|');
    final newSig = widget.initialImages.map((d) => d.stableKey).join('|');
    if (oldSig != newSig) {
      _items = List.from(widget.initialImages);
    }
  }

  void _notify() => widget.onChanged?.call(_items);

  Future<void> _pickMultiple() async {
    final remaining = widget.maxImages - _items.length;
    if (remaining <= 0) return;

    final picked = await _picker.pickMultiImage(
      imageQuality: 85,
      limit: remaining,
    );
    if (picked.isEmpty) return;

    setState(() {
      _items.addAll(
        picked.take(remaining).map((x) => ProductImageDraft.fromFile(File(x.path))),
      );
    });
    _notify();
  }

  Future<void> _replaceAt(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      _items[index] = ProductImageDraft.fromFile(File(picked.path));
    });
    _notify();
  }

  void _removeAt(int index) {
    setState(() => _items.removeAt(index));
    _notify();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Foto Produk',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${_items.length}/${widget.maxImages}',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (widget.showHint) ...[
          SizedBox(height: 3.h),
          Text(
            'Tahan ikon grip lalu geser untuk ubah urutan. Foto pertama = cover.',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textHint,
              height: 1.25,
            ),
          ),
        ],
        SizedBox(height: 8.h),
        SizedBox(
          height: 84.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _items.isEmpty
                    ? _buildEmptyPlaceholder()
                    : ReorderableListView.builder(
                        scrollDirection: Axis.horizontal,
                        buildDefaultDragHandles: false,
                        padding: EdgeInsets.zero,
                        itemCount: _items.length,
                        onReorder: _onReorder,
                        proxyDecorator: (child, index, animation) {
                          return Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.transparent,
                            child: child,
                          );
                        },
                        itemBuilder: (context, index) {
                          return _ImageTile(
                            key: ValueKey(_items[index].stableKey),
                            draft: _items[index],
                            isCover: index == 0,
                            onDelete: () => _removeAt(index),
                            onReplace: () => _replaceAt(index),
                            dragHandle: ReorderableDragStartListener(
                              index: index,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Icon(
                                  LucideIcons.gripVertical,
                                  size: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (_items.length < widget.maxImages) ...[
                SizedBox(width: 8.w),
                _buildAddButton(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return GestureDetector(
      onTap: _pickMultiple,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200, width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.imagePlus, color: AppColors.primary, size: 22.sp),
            SizedBox(height: 4.h),
            Text(
              'Tambah Foto',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _pickMultiple,
      child: Container(
        width: 68.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus, color: AppColors.primary, size: 18.sp),
            SizedBox(height: 3.h),
            Text(
              'Tambah',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final ProductImageDraft draft;
  final bool isCover;
  final VoidCallback onDelete;
  final VoidCallback onReplace;
  final Widget dragHandle;

  const _ImageTile({
    super.key,
    required this.draft,
    required this.isCover,
    required this.onDelete,
    required this.onReplace,
    required this.dragHandle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: SizedBox(
        width: 80.w,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: draft.isRemote
                  ? BisaNetworkImage(
                      imageUrl: draft.remoteUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => BisaMediaSkeleton(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.grey100,
                        child: Icon(LucideIcons.imageOff, color: AppColors.grey400),
                      ),
                    )
                  : Image.file(draft.localFile!, fit: BoxFit.cover),
            ),
            if (isCover)
              Positioned(
                left: 6.w,
                bottom: 6.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Cover',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            Positioned(top: 4.h, left: 4.w, child: dragHandle),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.x, size: 11.sp, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              right: 4.w,
              bottom: 6.h,
              child: GestureDetector(
                onTap: onReplace,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(LucideIcons.pencil, size: 11.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
