import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/marketplace_cubit.dart';
import '../bloc/category_cubit.dart';
import '../widgets/supplier_quick_actions.dart';
import '../widgets/supplier_product_tile.dart';
import '../../../../shared/widgets/supplier_product_tile_skeleton.dart';
import '../widgets/supplier_product_category_bar.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/notification_bell_button.dart';

class StoreManagementPage extends StatefulWidget {
  const StoreManagementPage({super.key});

  static const int _previewLimit = 4;

  @override
  State<StoreManagementPage> createState() => _StoreManagementPageState();
}

class _StoreManagementPageState extends State<StoreManagementPage> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CategoryCubit>().getCategories();
    });
  }

  void _reloadProducts(BuildContext blocContext, String? userId) {
    blocContext.read<MarketplaceCubit>().getProducts(
          userId: userId,
          categoryId: _selectedCategoryId,
          limit: StoreManagementPage._previewLimit,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

    return BlocProvider(
      create: (context) => sl<MarketplaceCubit>()
        ..getProducts(
          userId: user?.id,
          categoryId: _selectedCategoryId,
          limit: StoreManagementPage._previewLimit,
        ),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              backgroundColor: AppColors.surface,
              showBackButton: false,
              centerTitle: false,
              title: 'Manajemen Produk',
              actions: [
                const NotificationBellButton(),
                BisaAppBarAction(
                  icon: LucideIcons.plus,
                  onTap: () => blocContext.push('/add-product'),
                  iconColor: AppColors.primary,
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async => _reloadProducts(blocContext, user?.id),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SupplierQuickActions(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                      child: SupplierProductCategoryBar(
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: (category) {
                          setState(() => _selectedCategoryId = category?.id);
                          _reloadProducts(blocContext, user?.id);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Produk Anda',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                blocContext.push('/product-management'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Lihat semua produk',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  LucideIcons.chevronRight,
                                  size: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<MarketplaceCubit, MarketplaceState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => SizedBox(height: 120.h),
                          loading: () => Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                            child: Column(
                              children: List.generate(
                                3,
                                (i) => Padding(
                                  padding: EdgeInsets.only(bottom: i < 2 ? 10.h : 0),
                                  child: const SupplierProductTileSkeleton(),
                                ),
                              ),
                            ),
                          ),
                          error: (message) => Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              children: [
                                Text(message, textAlign: TextAlign.center),
                                TextButton(
                                  onPressed: () =>
                                      _reloadProducts(blocContext, user?.id),
                                  child: Text('coba_lagi'.tr()),
                                ),
                              ],
                            ),
                          ),
                          suppliersLoaded: (_) => const SizedBox.shrink(),
                          collectionsLoaded: (_) => const SizedBox.shrink(),
                          loaded: (products, _) =>
                              _buildProductPreview(
                            blocContext,
                            products,
                            user?.id,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductPreview(
    BuildContext blocContext,
    List<ProductEntity> products,
    String? userId,
  ) {
    if (products.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        child: Column(
          children: [
            Icon(
              LucideIcons.packageSearch,
              size: 56.r,
              color: AppColors.grey200,
            ),
            SizedBox(height: 12.h),
            Text(
              'Belum ada produk'.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Mulai tambahkan produk pertama Anda'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            OutlinedButton.icon(
              onPressed: () => blocContext.push('/add-product'),
              icon: Icon(LucideIcons.plus, size: 18.sp),
              label: const Text('Tambah Produk'),
            ),
          ],
        ),
      );
    }

    final preview = products.take(StoreManagementPage._previewLimit).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Column(
        children: [
          for (var i = 0; i < preview.length; i++) ...[
            if (i > 0) SizedBox(height: 12.h),
            SupplierProductTile(
              product: preview[i],
              onTap: () async {
                await blocContext.push('/product-manage/${preview[i].id}');
                if (blocContext.mounted) {
                  _reloadProducts(blocContext, userId);
                }
              },
              onEdit: () => blocContext.push(
                '/edit-product',
                extra: preview[i],
              ),
              onDelete: () => showSupplierDeleteProductDialog(
                context: blocContext,
                product: preview[i],
                onConfirm: () => blocContext
                    .read<MarketplaceCubit>()
                    .deleteProduct(preview[i].id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
