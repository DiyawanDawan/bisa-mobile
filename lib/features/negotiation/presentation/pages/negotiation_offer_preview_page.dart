import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/models/negotiation_offer_draft.dart';
import '../bloc/negotiation_cubit.dart';
import '../widgets/negotiation_product_preview.dart';
import '../widgets/negotiation_seller_chip.dart';
import '../widgets/negotiation_stock_banner.dart';
import '../utils/negotiation_quantity_rules.dart';
import '../../../../core/utils/product_pricing.dart';

/// Ringkasan penawaran sebelum dikirim ke penjual.
class NegotiationOfferPreviewPage extends StatelessWidget {
  const NegotiationOfferPreviewPage({super.key, required this.draft});

  final NegotiationOfferDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: BisaAppBar(
        title: 'negotiation.preview_title'.tr(),
        onBackTap: () => context.pop(draft),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NegotiationSellerChip(
                    displayName: draft.sellerDisplayName,
                    avatarUrl: draft.sellerAvatarUrl,
                    isVerified: draft.sellerIsVerified,
                  ),
                  SizedBox(height: AppSpacing.sm10),
                  NegotiationProductPreview(
                    name: draft.productName,
                    thumbnailUrl: draft.productThumbnailUrl,
                    priceLabel: formatMoneyIdr(draft.catalogPricePerUnit),
                    subtitle: 'negotiation.preview_catalog_price'.tr(),
                  ),
                  SizedBox(height: AppSpacing.sm10),
                  NegotiationStockBanner(
                    stock: draft.stock,
                    minOrder: draft.minOrder,
                    unit: draft.unit,
                    requestedQty: draft.quantity,
                  ),
                  SizedBox(height: AppSpacing.md),
                  _ComparisonCard(draft: draft),
                  SizedBox(height: AppSpacing.md12),
                  _QuantityRow(draft: draft),
                  if (draft.message != null && draft.message!.trim().isNotEmpty) ...[
                    SizedBox(height: AppSpacing.md12),
                    _NoteCard(message: draft.message!),
                  ],
                  if (draft.localImagePath != null) ...[
                    SizedBox(height: AppSpacing.md12),
                    _AttachmentPreview(path: draft.localImagePath!),
                  ],
                  SizedBox(height: AppSpacing.md12),
                  _InfoNote(draft: draft),
                ],
              ),
            ),
          ),
          _BottomActions(draft: draft),
        ],
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.draft});

  final NegotiationOfferDraft draft;

  @override
  Widget build(BuildContext context) {
    final savings = draft.totalSavings;
    final pct = draft.discountTotalPercent.abs();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'negotiation.preview_price_compare'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.section),
          _PriceCompareRow(
            label: 'negotiation.preview_price_initial_per'.tr(
              namedArgs: {'unit': draft.unit},
            ),
            value: formatMoneyIdr(draft.catalogPricePerUnit),
            tone: _RowTone.neutral,
            strikethrough: draft.hasDiscount,
          ),
          SizedBox(height: AppSpacing.sm10),
          _PriceCompareRow(
            label: 'negotiation.preview_price_offer_per'.tr(
              namedArgs: {'unit': draft.unit},
            ),
            value: formatMoneyIdr(draft.offerPricePerUnit),
            tone: draft.hasDiscount
                ? _RowTone.success
                : draft.isHigherThanCatalog
                    ? _RowTone.warning
                    : _RowTone.primary,
          ),
          if (draft.hasDiscount) ...[
            SizedBox(height: AppSpacing.sm10),
            _PriceCompareRow(
              label: 'negotiation.preview_savings_per'.tr(
                namedArgs: {'unit': draft.unit},
              ),
              value:
                  '${formatMoneyIdr(draft.catalogPricePerUnit - draft.offerPricePerUnit)} (${pct.toStringAsFixed(1)}%)',
              tone: _RowTone.success,
            ),
          ] else if (draft.isHigherThanCatalog) ...[
            SizedBox(height: AppSpacing.sm10),
            _PriceCompareRow(
              label: 'negotiation.preview_diff_per'.tr(
                namedArgs: {'unit': draft.unit},
              ),
              value:
                  '+${formatMoneyIdr(draft.offerPricePerUnit - draft.catalogPricePerUnit)}',
              tone: _RowTone.warning,
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
            child: const Divider(height: 1, color: AppColors.grey100),
          ),
          _PriceCompareRow(
            label: 'negotiation.preview_total_initial'.tr(),
            value: formatMoneyIdr(draft.catalogSubtotal),
            tone: _RowTone.neutral,
            strikethrough: draft.hasDiscount,
          ),
          SizedBox(height: AppSpacing.sm),
          _PriceCompareRow(
            label: 'negotiation.preview_total_offer'.tr(),
            value: formatMoneyIdr(draft.offerSubtotal),
            tone: _RowTone.primary,
            emphasized: true,
          ),
          if (draft.hasDiscount) ...[
            SizedBox(height: AppSpacing.md12),
            Container(
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.badgePercent,
                    size: 20.sp,
                    color: AppColors.success,
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Text(
                      'negotiation.preview_savings_total'.tr(
                        namedArgs: {
                          'amount': formatMoneyIdr(savings),
                          'percent': pct.toStringAsFixed(1),
                        },
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _RowTone { neutral, primary, success, warning }

class _PriceCompareRow extends StatelessWidget {
  const _PriceCompareRow({
    required this.label,
    required this.value,
    required this.tone,
    this.emphasized = false,
    this.strikethrough = false,
  });

  final String label;
  final String value;
  final _RowTone tone;
  final bool emphasized;
  final bool strikethrough;

  Color get _valueColor {
    switch (tone) {
      case _RowTone.success:
        return AppColors.success;
      case _RowTone.warning:
        return AppColors.warning;
      case _RowTone.primary:
        return AppColors.primary;
      case _RowTone.neutral:
        return AppColors.textPrimary;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 15.sp : 13.sp,
            fontWeight: FontWeight.w900,
            color: strikethrough ? AppColors.error : _valueColor,
            decoration:
                strikethrough ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.error,
            decorationThickness: strikethrough ? 2 : null,
          ),
        ),
      ],
    );
  }
}

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({required this.draft});

  final NegotiationOfferDraft draft;

  @override
  Widget build(BuildContext context) {
    final qtyInvalid = !draft.isQuantityValid;
    final qtyLabel = ProductPricingInfo.formatQty(draft.quantity);
    final stockLabel = NegotiationQuantityRules.formatStock(
      draft.stock,
      draft.unit,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: qtyInvalid
              ? AppColors.error.withValues(alpha: 0.4)
              : AppColors.grey100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.package,
                size: 18.sp,
                color: qtyInvalid ? AppColors.error : AppColors.primary,
              ),
              SizedBox(width: AppSpacing.sm10),
              Text(
                'negotiation.preview_order_qty'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '$qtyLabel ${draft.unit}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: qtyInvalid ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(LucideIcons.warehouse, size: 14.sp, color: AppColors.textHint),
              SizedBox(width: 6.w),
              Text(
                'negotiation.preview_stock_available'.tr(
                  namedArgs: {'stock': stockLabel},
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (qtyInvalid) ...[
            SizedBox(height: 6.h),
            Text(
              NegotiationQuantityRules.validate(
                    quantity: draft.quantity,
                    minOrder: draft.minOrder,
                    stock: draft.stock,
                    unit: draft.unit,
                  ) ??
                  'negotiation.preview_qty_invalid'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'negotiation.preview_note_for_seller'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Image.file(
        File(path),
        height: 120.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.draft});

  final NegotiationOfferDraft draft;

  @override
  Widget build(BuildContext context) {
    final text = draft.isHigherThanCatalog
        ? 'negotiation.preview_note_higher'.tr()
        : 'negotiation.preview_note_normal'.tr();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 16.sp, color: AppColors.info),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.draft});

  final NegotiationOfferDraft draft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocConsumer<NegotiationCubit, NegotiationState>(
          listener: (context, state) {
            state.maybeWhen(
              detailLoaded: (negotiation, _, __) {
                context.pop();
                context.push('/negotiation/${negotiation.id}');
              },
              error: (message) => showErrorSnackBar(context, message),
              orElse: () {},
            );
          },
          builder: (context, state) {
            final loading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );
            final canSend = draft.isQuantityValid && !loading;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  text: 'negotiation.preview_edit_offer'.tr(),
                  height: AppSpacing.buttonHeightSm,
                  isOutlined: true,
                  onPressed: loading ? null : () => context.pop(draft),
                ),
                SizedBox(height: AppSpacing.sm10),
                CustomButton(
                  text: canSend
                      ? 'negotiation.preview_send_offer'.tr()
                      : 'negotiation.preview_fix_qty'.tr(),
                  height: 48.h,
                  useGradient: true,
                  isLoading: loading,
                  onPressed: canSend
                      ? () async {
                          if (!await ReadinessGate.ensureBuyerReady(context)) {
                            return;
                          }
                          if (!context.mounted) return;
                          context.read<NegotiationCubit>().createOffer(
                                productId: draft.productId,
                                quantity: draft.quantity,
                                pricePerUnit: draft.offerPricePerUnit,
                                message: draft.message,
                                localImagePath: draft.localImagePath,
                              );
                        }
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
