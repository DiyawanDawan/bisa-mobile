import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';
import '../../data/models/product_model.dart';
import 'product_card.dart';

class ProductRecommendationsSection extends StatefulWidget {
  const ProductRecommendationsSection({super.key, required this.productId});

  final String productId;

  @override
  State<ProductRecommendationsSection> createState() =>
      _ProductRecommendationsSectionState();
}

class _ProductRecommendationsSectionState
    extends State<ProductRecommendationsSection> {
  List<ProductModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await sl<ApiClient>().dio.get(
        '/products/${widget.productId}/recommendations',
        queryParameters: {'limit': 8},
      );
      final raw = res.data['data'] as List? ?? [];
      if (!mounted) return;
      setState(() {
        _items = raw
            .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        child: SizedBox(
          height: 120.h,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    if (_items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
          child: Row(
            children: [
              Icon(LucideIcons.sparkles, size: 18.sp, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'product.recommendations_title'.tr(),
                  style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _items.length,
            separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md12),
            itemBuilder: (context, i) {
              final p = _items[i].toEntity();
              return SizedBox(
                width: 160.w,
                child: ProductCard(
                  product: p,
                  onTap: () => context.push('/product/${p.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
