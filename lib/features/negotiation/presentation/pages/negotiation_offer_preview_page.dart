import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../core/utils/extensions.dart';
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
        title: 'Ringkasan Penawaran',
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
                  SizedBox(height: 10.h),
                  NegotiationProductPreview(
                    name: draft.productName,
                    thumbnailUrl: draft.productThumbnailUrl,
                    priceLabel: draft.catalogPricePerUnit.toRupiah,
                    subtitle: 'Harga di katalog',
                  ),
                  SizedBox(height: 10.h),
                  NegotiationStockBanner(
                    stock: draft.stock,
                    minOrder: draft.minOrder,
                    unit: draft.unit,
                    requestedQty: draft.quantity,
                  ),
                  SizedBox(height: 16.h),
                  _ComparisonCard(draft: draft),
                  SizedBox(height: 12.h),
                  _QuantityRow(draft: draft),
                  if (draft.message != null && draft.message!.trim().isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    _NoteCard(message: draft.message!),
                  ],
                  if (draft.localImagePath != null) ...[
                    SizedBox(height: 12.h),
                    _AttachmentPreview(path: draft.localImagePath!),
                  ],
                  SizedBox(height: 12.h),
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Perbandingan harga',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 14.h),
          _PriceCompareRow(
            label: 'Harga awal / ${draft.unit}',
            value: draft.catalogPricePerUnit.toRupiah,
            tone: _RowTone.neutral,
            strikethrough: draft.hasDiscount,
          ),
          SizedBox(height: 10.h),
          _PriceCompareRow(
            label: 'Harga tawaran / ${draft.unit}',
            value: draft.offerPricePerUnit.toRupiah,
            tone: draft.hasDiscount
                ? _RowTone.success
                : draft.isHigherThanCatalog
                    ? _RowTone.warning
                    : _RowTone.primary,
          ),
          if (draft.hasDiscount) ...[
            SizedBox(height: 10.h),
            _PriceCompareRow(
              label: 'Hemat per ${draft.unit}',
              value:
                  '${(draft.catalogPricePerUnit - draft.offerPricePerUnit).toRupiah} (${pct.toStringAsFixed(1)}%)',
              tone: _RowTone.success,
            ),
          ] else if (draft.isHigherThanCatalog) ...[
            SizedBox(height: 10.h),
            _PriceCompareRow(
              label: 'Selisih per ${draft.unit}',
              value:
                  '+${(draft.offerPricePerUnit - draft.catalogPricePerUnit).toRupiah}',
              tone: _RowTone.warning,
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(height: 1, color: AppColors.grey100),
          ),
          _PriceCompareRow(
            label: 'Total harga awal',
            value: draft.catalogSubtotal.toRupiah,
            tone: _RowTone.neutral,
            strikethrough: draft.hasDiscount,
          ),
          SizedBox(height: 8.h),
          _PriceCompareRow(
            label: 'Total penawaran Anda',
            value: draft.offerSubtotal.toRupiah,
            tone: _RowTone.primary,
            emphasized: true,
          ),
          if (draft.hasDiscount) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.badgePercent,
                    size: 20.sp,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Anda menghemat ${savings.toRupiah} '
                      '(${pct.toStringAsFixed(1)}% dari total katalog)',
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
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
              SizedBox(width: 10.w),
              Text(
                'Jumlah pesanan',
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
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(LucideIcons.warehouse, size: 14.sp, color: AppColors.textHint),
              SizedBox(width: 6.w),
              Text(
                'Stok tersedia: $stockLabel',
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
                  'Jumlah tidak valid',
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catatan untuk penjual',
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
      borderRadius: BorderRadius.circular(12.r),
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
        ? 'Harga tawaran Anda di atas katalog. Penjual bisa menolak atau menawar balik.'
        : 'Setelah dikirim, penjual akan membalas di chat negosiasi. '
            'Anda masih bisa ubah penawaran sebelum menekan kirim.';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 16.sp, color: AppColors.info),
          SizedBox(width: 8.w),
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
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
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
                  text: 'Ubah penawaran',
                  height: 44.h,
                  isOutlined: true,
                  onPressed: loading ? null : () => context.pop(draft),
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  text: canSend
                      ? 'Kirim negosiasi ke penjual'
                      : 'Perbaiki jumlah pesanan',
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
