import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/negotiation/domain/entities/negotiation_entity.dart';
import 'package:mobile_bisa/features/negotiation/domain/entities/negotiation_entity_extensions.dart';
import 'package:mobile_bisa/features/negotiation/presentation/bloc/negotiation_cubit.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_deal_economics.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_deal_economics_card.dart';
import 'package:mobile_bisa/features/negotiation/presentation/utils/negotiation_status_ui.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';

class NegotiationProductPage extends StatelessWidget {
  final String negotiationId;

  const NegotiationProductPage({super.key, required this.negotiationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NegotiationCubit>()..getDetail(negotiationId),
      child: BlocBuilder<NegotiationCubit, NegotiationState>(
        builder: (context, state) {
          return state.maybeWhen(
            detailLoaded: (negotiation, isTyping, _) {
              final currentUserId = context.select(
                (AuthCubit c) => c.state.maybeWhen(
                  authenticated: (user) => user.id,
                  orElse: () => null,
                ),
              );
              final isSellerInRoom = currentUserId != null &&
                  negotiation.isSellerParticipant(currentUserId);
              return _NegotiationProductBody(
                negotiation: negotiation,
                isSupplier: isSellerInRoom,
              );
            },
            loading: () => Scaffold(
              backgroundColor: AppColors.background,
              appBar: BisaAppBar(
                title: 'negotiation.product_page_title'.tr(),
                backgroundColor: AppColors.surface,
              ),
              body: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 88),
              ),
            ),
            error: (message) => Scaffold(
              backgroundColor: AppColors.background,
              appBar: BisaAppBar(
                title: 'negotiation.product_page_title'.tr(),
                backgroundColor: AppColors.surface,
              ),
              body: Center(child: Text(message.localizedFailure)),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _NegotiationProductBody extends StatelessWidget {
  final NegotiationEntity negotiation;
  final bool isSupplier;

  const _NegotiationProductBody({
    required this.negotiation,
    required this.isSupplier,
  });

  @override
  Widget build(BuildContext context) {
    final product = negotiation.product;
    final party = isSupplier ? negotiation.buyer : negotiation.seller;
    final partyLabel = isSupplier
        ? 'negotiation.product_party_buyer'.tr()
        : 'negotiation.product_party_supplier'.tr();
    final economics = negotiation.economics ??
        InvoiceDealEconomics.compute(
          catalogPricePerUnit: product.pricePerUnit,
          negotiatedPricePerUnit: negotiation.pricePerUnit,
          quantity: negotiation.quantity,
          platformFee: 0,
          productStock: product.stock,
          unit: product.unit,
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'negotiation.product_page_title'.tr(),
        backgroundColor: AppColors.surface,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productHeader(product),
            SizedBox(height: AppSpacing.md),
            _section(
              title: 'negotiation.product_deal_title'.tr(),
              child: Column(
                children: [
                  _row(
                    'negotiation.product_label_status'.tr(),
                    NegotiationStatusDisplay.forList(negotiation.status).label,
                  ),
                  _row(
                    'negotiation.product_label_qty'.tr(),
                    '${negotiation.quantity.toStringAsFixed(0)} ${product.unit}',
                  ),
                  _row(
                    'negotiation.product_label_nego_price'.tr(),
                    formatMoneyIdr(negotiation.pricePerUnit),
                  ),
                  _row(
                    'negotiation.product_label_total'.tr(),
                    formatMoneyIdr(negotiation.totalEstimate),
                    isBold: true,
                  ),
                  if (negotiation.specifications != null &&
                      negotiation.specifications!.isNotEmpty)
                    _row(
                      'negotiation.product_label_note'.tr(),
                      negotiation.specifications!,
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.section),
            InvoiceDealEconomicsCard(economics: economics),
            SizedBox(height: AppSpacing.section),
            _section(
              title: 'negotiation.product_metadata_title'.tr(),
              child: Column(
                children: [
                  _row(
                    'negotiation.product_label_catalog_price'.tr(),
                    formatMoneyDisplay(product.pricePerUnit),
                  ),
                  _row(
                    'negotiation.product_label_stock'.tr(),
                    '${product.stock.toStringAsFixed(0)} ${product.unit}',
                  ),
                  _row(
                    'negotiation.product_label_min_order'.tr(),
                    '${product.minOrder.toStringAsFixed(0)} ${product.unit}',
                  ),
                  if (product.biomassaType != null)
                    _row(
                      'negotiation.product_label_biomass'.tr(),
                      product.biomassaType!,
                    ),
                  if (product.regency != null || product.province != null)
                    _row(
                      'negotiation.product_label_location'.tr(),
                      [product.regency, product.province]
                          .whereType<String>()
                          .where((e) => e.isNotEmpty)
                          .join(', '),
                    ),
                  if (product.status != null)
                    _row(
                      'negotiation.product_label_product_status'.tr(),
                      product.status!,
                    ),
                  if (product.description != null && product.description!.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      product.description!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: AppSpacing.section),
            _section(
              title: partyLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    party.companyName ?? party.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (party.companyName != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      party.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            if (isSupplier)
              CustomButton(
                text: 'negotiation.product_manage_full'.tr(),
                height: 48.h,
                isOutlined: true,
                onPressed: () => context.push('/product-manage/${product.id}'),
              )
            else
              CustomButton(
                text: 'negotiation.product_view_marketplace'.tr(),
                height: 48.h,
                isOutlined: true,
                onPressed: () => context.push('/product/${product.id}'),
              ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: 'negotiation.back_to_chat'.tr(),
              height: 48.h,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productHeader(NegotiationProductEntity product) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: product.thumbnailUrl != null && product.thumbnailUrl!.isNotEmpty
                ? BisaNetworkImage(
                    imageUrl: product.thumbnailUrl!,
                    width: 72.w,
                    height: 72.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 72.w,
                    height: 72.w,
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                  ),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'negotiation.product_id_prefix'.tr(
                    namedArgs: {'id': '${product.id.substring(0, 8)}...'},
                  ),
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: AppSpacing.sm10),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isBold ? 14.sp : 12.sp,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
