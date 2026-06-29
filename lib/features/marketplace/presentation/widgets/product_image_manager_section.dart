import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
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
      showErrorSnackBar(context, 'marketplace.min_one_photo_required');
      return;
    }
    final error = await context.read<ProductManagementCubit>().updateImages(
          widget.product.id,
          _drafts,
        );
    if (!mounted) return;
    if (error != null) {
      showErrorSnackBar(context, error);
      return;
    }
    showSuccessSnackBar(context, 'marketplace.photos_saved');
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
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
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
                SizedBox(height: AppSpacing.sm10),
                BlocBuilder<ProductManagementCubit, ProductManagementState>(
                  builder: (context, state) {
                    final loading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    return CustomButton(
                      text: 'marketplace.save_photo_changes'.tr(),
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
