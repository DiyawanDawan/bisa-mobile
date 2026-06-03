import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_image_draft.dart';
import '../bloc/product_management_cubit.dart';
import 'product_image_editor.dart';

class ProductImageManagerSection extends StatefulWidget {
  final ProductEntity product;

  const ProductImageManagerSection({super.key, required this.product});

  @override
  State<ProductImageManagerSection> createState() =>
      _ProductImageManagerSectionState();
}

class _ProductImageManagerSectionState extends State<ProductImageManagerSection> {
  late List<ProductImageDraft> _drafts;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _drafts = _draftsFromProduct(widget.product);
  }

  List<ProductImageDraft> _draftsFromProduct(ProductEntity product) {
    final drafts = ProductImageDraft.fromProductImages(product.images);
    if (drafts.isEmpty && product.thumbnailUrl != null) {
      return [
        ProductImageDraft(
          id: 'thumb',
          remoteUrl: product.thumbnailUrl,
        ),
      ];
    }
    return drafts;
  }

  String _draftSignature(List<ProductImageDraft> drafts) =>
      drafts.map((d) => d.stableKey).join('|');

  String _productImageSignature(ProductEntity product) {
    final imageUrls = product.images?.map((e) => e.url).join('|') ?? '';
    return '${product.thumbnailUrl ?? ''}#$imageUrls';
  }

  void _syncDraftsFromProduct(ProductEntity product) {
    final nextDrafts = _draftsFromProduct(product);
    final nextSig = _draftSignature(nextDrafts);
    if (_draftSignature(_drafts) == nextSig && !_dirty) return;
    setState(() {
      _drafts = nextDrafts;
      _dirty = false;
    });
  }

  @override
  void didUpdateWidget(ProductImageManagerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _syncDraftsFromProduct(widget.product);
      return;
    }
    if (_productImageSignature(oldWidget.product) !=
        _productImageSignature(widget.product)) {
      _syncDraftsFromProduct(widget.product);
    }
  }

  Future<void> _save() async {
    if (_drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal satu foto produk diperlukan'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final error = await context.read<ProductManagementCubit>().updateImages(
          widget.product.id,
          _drafts,
        );
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto produk berhasil disimpan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductManagementCubit, ProductManagementState>(
      listenWhen: (previous, current) {
        final prevSig = previous.maybeWhen(
          loaded: (p, _) => p.id == widget.product.id ? _productImageSignature(p) : null,
          orElse: () => null,
        );
        final currSig = current.maybeWhen(
          loaded: (p, _) => p.id == widget.product.id ? _productImageSignature(p) : null,
          orElse: () => null,
        );
        return prevSig != currSig && currSig != null;
      },
      listener: (context, state) {
        state.maybeWhen(
          loaded: (product, _) {
            if (product.id == widget.product.id) {
              _syncDraftsFromProduct(product);
            }
          },
          orElse: () {},
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey100),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageEditor(
                key: ValueKey(_draftSignature(_drafts)),
                initialImages: _drafts,
                onChanged: (items) {
                  setState(() {
                    _drafts = items;
                    _dirty = true;
                  });
                },
              ),
              if (_dirty) ...[
                SizedBox(height: 10.h),
                BlocBuilder<ProductManagementCubit, ProductManagementState>(
                  builder: (context, state) {
                    final loading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    return CustomButton(
                      text: 'Simpan Perubahan Foto',
                      isLoading: loading,
                      onPressed: loading ? null : _save,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
