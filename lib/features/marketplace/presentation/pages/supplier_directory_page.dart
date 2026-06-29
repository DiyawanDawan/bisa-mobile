import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_search_field.dart';
import '../bloc/marketplace_cubit.dart';
import '../../../follow/presentation/widgets/follow_button.dart';
import '../../../../injection_container.dart';
import '../../data/models/supplier_model.dart';

class SupplierDirectoryPage extends StatefulWidget {
  const SupplierDirectoryPage({super.key});

  @override
  State<SupplierDirectoryPage> createState() => _SupplierDirectoryPageState();
}

class _SupplierDirectoryPageState extends State<SupplierDirectoryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MarketplaceCubit>()..getSuppliers(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'marketplace.supplier_directory'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: Column(
          children: [
            _buildSearchBox(context),
            Expanded(
              child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => _buildLoadingList(),
                    error: (message) => Center(child: Text(message.localizedFailure)),
                    suppliersLoaded: (suppliers) {
                      if (suppliers.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.separated(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        itemCount: suppliers.length,
                        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md12),
                        itemBuilder: (context, index) {
                          final s = suppliers[index];
                          return _buildSupplierCard(context, s);
                        },
                      );
                    },
                    orElse: () => _buildLoadingList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      child: BisaSearchField(
        controller: _searchController,
        hint: 'marketplace.search_supplier'.tr(),
        onChanged: (val) =>
            context.read<MarketplaceCubit>().getSuppliers(search: val),
        onClear: () {
          _searchController.clear();
          context.read<MarketplaceCubit>().getSuppliers(search: '');
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.store,
              size: 64.sp,
              color: AppColors.grey300,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'marketplace.no_supplier_found'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context, SupplierModel s) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => context.push(
                '/supplier/${s.id}',
                extra: {'name': s.name},
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: resolveMediaImageProvider(s.avatar),
                    child: s.avatar == null
                        ? const Icon(LucideIcons.user)
                        : null,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                s.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (s.isVerified) ...[
                              SizedBox(width: 4.w),
                              Icon(
                                LucideIcons.check,
                                color: AppColors.info,
                                size: 14.sp,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${s.regency}, ${s.province}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.star,
                              color: AppColors.warning,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              s.rating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md12),
                            Text(
                              'marketplace.products_count'.tr(
                                namedArgs: {'count': '${s.totalProducts}'},
                              ),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.grey300,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm10),
          FollowButton(userId: s.id, compact: true),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.lg),
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md12),
        itemBuilder: (context, index) {
          return _buildSupplierCard(
            context,
            SupplierModel(
              id: '1',
              name: 'Supplier Name Placeholder',
              province: 'Province',
              regency: 'Regency',
              avatar: null,
              rating: 4.5,
              totalProducts: 10,
              isVerified: true,
            ),
          );
        },
      ),
    );
  }
}
