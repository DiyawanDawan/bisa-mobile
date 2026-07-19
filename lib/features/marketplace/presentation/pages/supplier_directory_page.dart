import 'dart:async';

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
  Timer? _searchDebounce;

  bool _verifiedOnly = false;
  String? _productMode; // BIOMASS_MATERIAL | ORGANIC_PRODUCE | null
  String? _biomassaType; // BIOCHAR | … when biomass mode

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _reload(BuildContext context) {
    context.read<MarketplaceCubit>().getSuppliers(
          search: _searchController.text.trim(),
          verified: _verifiedOnly ? true : null,
          productMode: _productMode,
          biomassaType: _productMode == 'BIOMASS_MATERIAL' ? _biomassaType : null,
        );
  }

  void _onSearchChanged(BuildContext context, String val) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _reload(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MarketplaceCubit>()..getSuppliers(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'marketplace.supplier_directory'.tr(),
              backgroundColor: AppColors.surface,
            ),
            body: Column(
              children: [
                _buildSearchBox(context),
                _buildFilterChips(context),
                if (_productMode == 'BIOMASS_MATERIAL')
                  _buildBiomassaChips(context),
                Expanded(
                  child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => _buildLoadingList(),
                        error: (message) => _buildErrorState(
                          context,
                          message.localizedFailure,
                        ),
                        suppliersLoaded: (suppliers) {
                          if (suppliers.isEmpty) {
                            return _buildEmptyState();
                          }
                          return RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async => _reload(context),
                            child: ListView.separated(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              itemCount: suppliers.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: AppSpacing.md12),
                              itemBuilder: (context, index) {
                                final s = suppliers[index];
                                return _buildSupplierCard(context, s);
                              },
                            ),
                          );
                        },
                        orElse: () => _buildLoadingList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      color: AppColors.surface,
      child: BisaSearchField(
        controller: _searchController,
        hint: 'marketplace.search_supplier'.tr(),
        onChanged: (val) => _onSearchChanged(context, val),
        onClear: () {
          _searchController.clear();
          _reload(context);
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'marketplace.filter_all'.tr(),
              selected: !_verifiedOnly && _productMode == null,
              onTap: () {
                setState(() {
                  _verifiedOnly = false;
                  _productMode = null;
                  _biomassaType = null;
                });
                _reload(context);
              },
            ),
            SizedBox(width: 8.w),
            _FilterChip(
              label: 'marketplace.filter_verified'.tr(),
              selected: _verifiedOnly,
              icon: LucideIcons.badgeCheck,
              onTap: () {
                setState(() => _verifiedOnly = !_verifiedOnly);
                _reload(context);
              },
            ),
            SizedBox(width: 8.w),
            _FilterChip(
              label: 'marketplace.filter_biomass'.tr(),
              selected: _productMode == 'BIOMASS_MATERIAL',
              onTap: () {
                setState(() {
                  if (_productMode == 'BIOMASS_MATERIAL') {
                    _productMode = null;
                    _biomassaType = null;
                  } else {
                    _productMode = 'BIOMASS_MATERIAL';
                    _biomassaType ??= 'BIOCHAR';
                  }
                });
                _reload(context);
              },
            ),
            SizedBox(width: 8.w),
            _FilterChip(
              label: 'marketplace.filter_organic'.tr(),
              selected: _productMode == 'ORGANIC_PRODUCE',
              onTap: () {
                setState(() {
                  if (_productMode == 'ORGANIC_PRODUCE') {
                    _productMode = null;
                  } else {
                    _productMode = 'ORGANIC_PRODUCE';
                    _biomassaType = null;
                  }
                });
                _reload(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiomassaChips(BuildContext context) {
    const types = <MapEntry<String, String>>[
      MapEntry('BIOCHAR', 'Biochar'),
      MapEntry('SEKAM_PADI', 'Sekam'),
      MapEntry('TONGKOL_JAGUNG', 'Tongkol'),
      MapEntry('TEMPURUNG_KELAPA', 'Tempurung'),
      MapEntry('WOOD_CHIP', 'Wood chip'),
      MapEntry('OTHER', 'Lainnya'),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < types.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              _FilterChip(
                label: types[i].value,
                selected: _biomassaType == types[i].key,
                compact: true,
                onTap: () {
                  setState(() {
                    _biomassaType =
                        _biomassaType == types[i].key ? null : types[i].key;
                  });
                  _reload(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.circleAlert, size: 40.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            TextButton.icon(
              onPressed: () => _reload(context),
              icon: Icon(LucideIcons.refreshCw, size: 16.sp),
              label: Text('marketplace.retry'.tr()),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
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
                                LucideIcons.badgeCheck,
                                color: AppColors.info,
                                size: 14.sp,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          s.locationLabel,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            if (s.rating > 0) ...[
                              Icon(
                                LucideIcons.star,
                                color: AppColors.warning,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                s.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(width: AppSpacing.md12),
                            ],
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
            const SupplierModel(
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool compact;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.grey100,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10.w : 12.w,
            vertical: compact ? 6.h : 8.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14.sp,
                  color: selected ? AppColors.surface : AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: compact ? 11.sp : 12.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.surface : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
