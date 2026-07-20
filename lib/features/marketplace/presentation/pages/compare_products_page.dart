import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/compare_cubit.dart';
import '../utils/product_specs_mapper.dart';
import '../widgets/compare_lists_sheet.dart';

class CompareProductsPage extends StatefulWidget {
  const CompareProductsPage({super.key});

  @override
  State<CompareProductsPage> createState() => _CompareProductsPageState();
}

class _CompareProductsPageState extends State<CompareProductsPage> {
  final Set<String> _selectedProductIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'product.compare_title'.tr(),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.list, size: 20.sp),
            tooltip: 'product.compare_saved_lists'.tr(),
            onPressed: () => CompareListsSheet.show(context),
          ),
          TextButton(
            onPressed: () => context.read<CompareCubit>().clear(),
            child: Text('product.compare_clear'.tr()),
          ),
        ],
      ),
      body: BlocBuilder<CompareCubit, CompareState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'product.compare_empty'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => context.pop(),
                      icon: Icon(LucideIcons.store, size: 18.sp),
                      label: Text('product.compare_pick_more'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          final needMore = state.products.length < 2;
          final selectedCount = _selectedProductIds.length;
          final selectedProducts = state.products
              .where((p) => _selectedProductIds.contains(p.id))
              .toList();

          return Column(
            children: [
              if (needMore)
                Material(
                  color: AppColors.primaryLight,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.info,
                          size: 18.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'product.compare_need_more'.tr(),
                            style: AppTextStyles.caption(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text('product.compare_pick_more'.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Comparison Table (Fixed Specs + Scrollable Products
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fixed Left Column (Spesifikasi - Fixed)
                            Container(
                              width: 120.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 190.h,
                                    decoration: const BoxDecoration(
                                      color: AppColors.surface,
                                      border: Border(
                                        bottom: BorderSide(color: AppColors.grey200, width: 2),
                                        right: BorderSide(color: AppColors.grey200, width: 1.5),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(AppSpacing.sm),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          LucideIcons.columns3,
                                          color: AppColors.primary,
                                          size: 20.sp,
                                        ),
                                        SizedBox(height: AppSpacing.sm),
                                        Text(
                                          'product.compare_spec'.tr(),
                                          style: AppTextStyles.caption(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'product.compare_spec_subtitle'.tr(),
                                          style: AppTextStyles.caption(
                                            color: AppColors.textSecondary,
                                          ).copyWith(
                                            fontSize: 9.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ..._buildFixedSpecLabels(state.products),
                                ],
                              ),
                            ),
                            // Scrollable Right Column (Products)
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ...state.products.map((product) {
                                          final isSelected = _selectedProductIds.contains(product.id);
                                          return Container(
                                            width: 140.w,
                                            child: _ProductHeaderCell(
                                              product: product,
                                              isSelected: isSelected,
                                              onRemove: () => context.read<CompareCubit>().remove(product.id),
                                              onSelect: (selected) {
                                                setState(() {
                                                  if (selected) {
                                                    _selectedProductIds.add(product.id);
                                                  } else {
                                                    _selectedProductIds.remove(product.id);
                                                  }
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                        Container(
                                          width: 140.w,
                                          child: _AddProductCell(onTap: () => context.pop()),
                                        ),
                                      ],
                                    ),
                                    ..._buildScrollableSpecValues(state.products),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selectedCount >= 2) ...[
                        SizedBox(height: AppSpacing.lg),
                        // Strategi Negosiasi
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: _BuildNegotiationStrategy(),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        // Draft Negosiasi
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: _BuildDraftNegotiation(
                            selectedCount: selectedCount,
                            selectedProducts: selectedProducts,
                          ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
              // Bottom Bar
              if (state.products.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: AppSpacing.buttonHeight,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Implement Simpan Draft
                            },
                            child: Text('product.compare_save_draft'.tr()),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SizedBox(
                          height: AppSpacing.buttonHeight,
                          child: FilledButton.icon(
                            onPressed: selectedCount >= 2
                                ? () {
                                    // TODO: Implement Buat Surat Negosiasi
                                  }
                                : null,
                            icon: Icon(LucideIcons.mail),
                            label: Text('product.compare_create_letter'.tr()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildFixedSpecLabels(List<ProductEntity> products) {
    final widgets = <Widget>[];

    // Price
    widgets.add(_specLabelCell('product.compare_unit_price'.tr(), isEven: true));

    // Min Order
    widgets.add(_specLabelCell('product.compare_moq_full'.tr(), isEven: false));

    // Rating
    widgets.add(_specLabelCell('product.compare_rating'.tr(), isEven: true));

    // Stock
    widgets.add(_specLabelCell('product.compare_stock'.tr(), isEven: false));

    // Additional Specs
    final labels = <String>{};
    for (final p in products) {
      for (final s in p.specs) {
        if (s.label.trim().isNotEmpty) labels.add(s.label.trim());
      }
    }
    final ordered = labels.toList()..sort();

    int index = 4;
    for (final label in ordered) {
      widgets.add(_specLabelCell(ProductSpecsMapper.displayLabel(label), isEven: index % 2 == 0));
      index++;
    }

    return widgets;
  }

  List<Widget> _buildScrollableSpecValues(List<ProductEntity> products) {
    final widgetRows = <Widget>[];
    final specGetters = <String Function(ProductEntity)>[];

    // Price
    specGetters.add((p) {
      final price = p.samplePricePerUnit ?? p.pricePerUnit;
      return '${formatMoneyDisplay(price)} / ${p.unit}';
    });

    // Min Order
    specGetters.add((p) => '${ProductPricingInfo.formatQty(p.minOrder)} ${p.unit}');

    // Rating
    specGetters.add((p) => '${p.averageRating} (${p.totalReviews})');

    // Stock
    specGetters.add((p) => '${p.stock} ${p.unit}');

    // Additional Specs
    final labels = <String>{};
    for (final p in products) {
      for (final s in p.specs) {
        if (s.label.trim().isNotEmpty) labels.add(s.label.trim());
      }
    }
    final ordered = labels.toList()..sort();

    for (final label in ordered) {
      specGetters.add((p) {
        final match = p.specs.where((s) => s.label.trim() == label);
        if (match.isEmpty) return '—';
        return ProductSpecsMapper.displayValue(match.first.value);
      });
    }

    // Build each spec row
    int index = 0;
    for (final getter in specGetters) {
      widgetRows.add(_specValuesRow(products, getter, isEven: index % 2 == 0));
      index++;
    }

    return widgetRows;
  }

  Widget _specLabelCell(String label, {required bool isEven}) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: isEven ? AppColors.surface : AppColors.grey50,
        border: const Border(
          bottom: BorderSide(color: AppColors.grey100),
          right: BorderSide(color: AppColors.grey200, width: 1.5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption(
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _specValuesRow(
    List<ProductEntity> products,
    String Function(ProductEntity) getter, {
    required bool isEven,
  }) {
    return Row(
      children: [
        ...products.map((p) {
          return Container(
            width: 140.w,
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isEven ? AppColors.surface : AppColors.grey50,
              border: const Border(
                bottom: BorderSide(color: AppColors.grey100),
                right: BorderSide(color: AppColors.grey100),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              getter(p),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(),
            ),
          );
        }),
        Container(
          width: 140.w,
          height: 52.h,
          decoration: BoxDecoration(
            color: isEven ? AppColors.surface : AppColors.grey50,
            border: const Border(
              bottom: BorderSide(color: AppColors.grey100),
              right: BorderSide(color: AppColors.grey100),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductHeaderCell extends StatelessWidget {
  const _ProductHeaderCell({
    required this.product,
    required this.isSelected,
    required this.onRemove,
    required this.onSelect,
  });

  final ProductEntity product;
  final bool isSelected;
  final VoidCallback onRemove;
  final Function(bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 2),
          right: BorderSide(color: AppColors.grey100),
        ),
      ),
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: BisaNetworkImage(
                  imageUrl: product.thumbnailUrl,
                  width: double.infinity,
                  height: 90.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2.h,
                left: 2.w,
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(
                    value: isSelected,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    side: const BorderSide(color: AppColors.grey400, width: 1.5),
                    onChanged: (value) {
                      if (value != null) {
                        onSelect(value);
                      }
                    },
                  ),
                ),
              ),
              Positioned(
                top: 2.h,
                right: 2.w,
                child: Material(
                  color: AppColors.black.withOpacity(0.6),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onRemove,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        LucideIcons.x,
                        size: 12.sp,
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(fontWeight: FontWeight.w700),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final ok = await context.read<CommerceCubit>().addToCart(
                          product.id,
                          product.minOrder,
                        );
                    if (!context.mounted) return;
                    if (ok) {
                      showSuccessSnackBar(
                        context,
                        'marketplace.added_to_cart'.tr(namedArgs: {
                          'qty': ProductPricingInfo.formatQty(product.minOrder),
                          'unit': product.unit,
                        }),
                      );
                    } else {
                      showErrorSnackBar(context, 'errors.generic'.tr());
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: Icon(LucideIcons.shoppingCart, size: 14.sp, color: AppColors.primary),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(
                    '/product/${product.id}?negotiate=1',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: AppColors.secondary),
                  ),
                  child: Icon(LucideIcons.messageCircle, size: 14.sp, color: AppColors.secondary),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.push('/product/${product.id}'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'product.compare_view_detail'.tr(),
                  style: AppTextStyles.caption(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 10.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddProductCell extends StatelessWidget {
  const _AddProductCell({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 2),
          right: BorderSide(color: AppColors.grey100),
        ),
      ),
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'product.compare_add'.tr(),
                  style: AppTextStyles.caption(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildNegotiationStrategy extends StatelessWidget {
  const _BuildNegotiationStrategy();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary),
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.lightbulb, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Text(
                'product.compare_strategy_title'.tr(),
                style: AppTextStyles.body(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
                  ),
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'product.compare_savings_title'.tr(),
                        style: AppTextStyles.caption(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'product.compare_savings_body'.tr(),
                        style: AppTextStyles.caption(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
                  ),
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'product.compare_logistics_title'.tr(),
                        style: AppTextStyles.caption(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'product.compare_logistics_body'.tr(),
                        style: AppTextStyles.caption(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BuildDraftNegotiation extends StatelessWidget {
  const _BuildDraftNegotiation({
    required this.selectedCount,
    required this.selectedProducts,
  });

  final int selectedCount;
  final List<ProductEntity> selectedProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'product.compare_draft_title'.tr(),
            style: AppTextStyles.body(
              fontWeight: FontWeight.w700,
              color: AppColors.textOnPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'product.compare_draft_body'.tr(
              namedArgs: {'count': '$selectedCount'},
            ),
            style: AppTextStyles.caption(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$selectedCount',
                style: AppTextStyles.sheetTitle(
                  color: AppColors.textOnPrimary,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    'product.compare_selected_label'.tr(),
                    style: AppTextStyles.caption(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Material(
                color: AppColors.surface.withValues(alpha: 0.2),
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Icon(
                      LucideIcons.pencil,
                      size: 18.sp,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int i = 0; i < selectedProducts.length && i < 2; i++)
                Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: BisaNetworkImage(
                      imageUrl: selectedProducts[i].thumbnailUrl,
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (selectedProducts.length > 2)
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      '+${selectedProducts.length - 2}',
                      style: AppTextStyles.body(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'product.compare_awaiting'.tr(),
                  style: AppTextStyles.caption(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductPricingInfo {
  static String formatQty(double qty) {
    if (qty == qty.roundToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }
}
