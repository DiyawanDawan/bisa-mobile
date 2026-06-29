import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/product_card.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/injection_container.dart';

class CollectionProductsPage extends StatefulWidget {
  final String title;
  final String? collectionSlug;
  final String? sortBy;
  final String? sortOrder;
  final String? productMode;

  const CollectionProductsPage({
    super.key,
    required this.title,
    this.collectionSlug,
    this.sortBy,
    this.sortOrder,
    this.productMode,
  });

  @override
  State<CollectionProductsPage> createState() => _CollectionProductsPageState();
}

class _CollectionProductsPageState extends State<CollectionProductsPage> {
  late final MarketplaceCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<MarketplaceCubit>();
    _scrollController.addListener(_onScroll);
    _fetchProducts();
  }

  void _fetchProducts({bool refresh = true}) {
    if (widget.collectionSlug != null) {
      _cubit.getProductsByCollection(
        widget.collectionSlug!,
        refresh: refresh,
      );
    } else {
      _cubit.getProducts(
        sortBy: widget.sortBy,
        sortOrder: widget.sortOrder,
        productMode: widget.productMode,
        refresh: refresh,
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchProducts(refresh: false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: widget.title,
          backgroundColor: AppColors.surface,
        ),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => _fetchProducts(),
          child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
            builder: (context, state) {
              return state.maybeWhen(
                initial: () => const SizedBox.shrink(),
                loading: () => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: const ShimmerProductGridPlaceholder(itemCount: 6),
                ),
                error: (message) => Center(child: Text(message.localizedFailure)),
                loaded: (products, hasReachedMax) {
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.packageSearch,
                            size: 64.sp,
                            color: AppColors.grey200,
                          ),
                          SizedBox(height: AppSpacing.lg),
                          Text(
                            'marketplace.no_products_found'.tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return MasonryGridView.count(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md12,
                    itemCount: products.length + (hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= products.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      return ProductCard(product: products[index]);
                    },
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }
}
