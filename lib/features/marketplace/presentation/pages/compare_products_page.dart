import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/compare_cubit.dart';
import '../utils/product_specs_mapper.dart';
import '../widgets/compare_lists_sheet.dart';

class CompareProductsPage extends StatelessWidget {
  const CompareProductsPage({super.key});

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

          final specRows = _buildSpecRows(state.products);
          final needMore = state.products.length < 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.surface),
                columns: [
                  DataColumn(
                    label: Text(
                      'product.compare_spec'.tr(),
                      style: AppTextStyles.caption(fontWeight: FontWeight.w800),
                    ),
                  ),
                  ...state.products.map(
                    (p) => DataColumn(
                      label: SizedBox(
                        width: 140.w,
                        child: _ProductHeader(
                          product: p,
                          onRemove: () =>
                              context.read<CompareCubit>().remove(p.id),
                        ),
                      ),
                    ),
                  ),
                ],
                rows: specRows,
              ),
            ),
          ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DataRow> _buildSpecRows(List<ProductEntity> products) {
    final labels = <String>{};
    for (final p in products) {
      for (final s in p.specs) {
        if (s.label.trim().isNotEmpty) labels.add(s.label.trim());
      }
    }
    final ordered = labels.toList()..sort();

    final rows = <DataRow>[
      _valueRow('product.compare_price'.tr(), products, (p) {
        final price = p.samplePricePerUnit ?? p.pricePerUnit;
        return '${formatMoneyDisplay(price)} / ${p.unit}';
      }),
      _valueRow('product.compare_moq'.tr(), products, (p) {
        return '${ProductPricingInfo.formatQty(p.minOrder)} ${p.unit}';
      }),
      _valueRow('product.compare_rating'.tr(), products,
          (p) => '${p.averageRating} (${p.totalReviews})'),
      _valueRow('product.compare_stock'.tr(), products,
          (p) => '${p.stock} ${p.unit}'),
    ];

    for (final label in ordered) {
      rows.add(
        _valueRow(ProductSpecsMapper.displayLabel(label), products, (p) {
          final match = p.specs.where((s) => s.label.trim() == label);
          if (match.isEmpty) return '—';
          return ProductSpecsMapper.displayValue(match.first.value);
        }),
      );
    }
    return rows;
  }

  DataRow _valueRow(
    String label,
    List<ProductEntity> products,
    String Function(ProductEntity) getter,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(label, style: AppTextStyles.caption())),
        ...products.map(
          (p) => DataCell(
            Text(
              getter(p),
              style: AppTextStyles.caption(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({
    required this.product,
    required this.onRemove,
  });

  final ProductEntity product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.button),
              child: BisaNetworkImage(
                imageUrl: product.thumbnailUrl,
                width: 120.w,
                height: 72.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: InkWell(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.x, size: 14.sp),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption(fontWeight: FontWeight.w800),
        ),
        TextButton(
          onPressed: () => context.push('/product/${product.id}'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('product.compare_view_detail'.tr()),
        ),
      ],
    );
  }
}

/// Minimal pricing helper for compare page (avoids importing negotiation widgets).
class ProductPricingInfo {
  static String formatQty(double qty) {
    if (qty == qty.roundToDouble()) return qty.toInt().toString();
    return qty.toStringAsFixed(1);
  }
}
