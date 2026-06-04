import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';
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
              appBar: const BisaAppBar(
                title: 'Produk Negosiasi',
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: EdgeInsets.all(16.w),
                child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 88),
              ),
            ),
            error: (message) => Scaffold(
              backgroundColor: AppColors.background,
              appBar: const BisaAppBar(
                title: 'Produk Negosiasi',
                backgroundColor: Colors.white,
              ),
              body: Center(child: Text(message)),
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
    final partyLabel = isSupplier ? 'Pembeli' : 'Supplier';
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
      appBar: const BisaAppBar(
        title: 'Produk Negosiasi',
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productHeader(product),
            SizedBox(height: 16.h),
            _section(
              title: 'Kesepakatan Negosiasi',
              child: Column(
                children: [
                  _row('Status', NegotiationStatusDisplay.forList(negotiation.status).label),
                  _row('Jumlah', '${negotiation.quantity.toStringAsFixed(0)} ${product.unit}'),
                  _row('Harga Nego/Unit', negotiation.pricePerUnit.toRupiah),
                  _row('Total Estimasi', negotiation.totalEstimate.toRupiah, isBold: true),
                  if (negotiation.specifications != null &&
                      negotiation.specifications!.isNotEmpty)
                    _row('Catatan', negotiation.specifications!),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            InvoiceDealEconomicsCard(economics: economics),
            SizedBox(height: 14.h),
            _section(
              title: 'Metadata Produk',
              child: Column(
                children: [
                  _row('Harga Katalog/Unit', product.pricePerUnit.toRupiah),
                  _row('Stok saat ini', '${product.stock.toStringAsFixed(0)} ${product.unit}'),
                  _row('Min. Order', '${product.minOrder.toStringAsFixed(0)} ${product.unit}'),
                  if (product.biomassaType != null)
                    _row('Jenis Biomassa', product.biomassaType!),
                  if (product.regency != null || product.province != null)
                    _row(
                      'Lokasi',
                      [product.regency, product.province]
                          .whereType<String>()
                          .where((e) => e.isNotEmpty)
                          .join(', '),
                    ),
                  if (product.status != null) _row('Status Produk', product.status!),
                  if (product.description != null && product.description!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
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
            SizedBox(height: 14.h),
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
            SizedBox(height: 20.h),
            if (isSupplier)
              CustomButton(
                text: 'Kelola Produk Lengkap',
                height: 48.h,
                isOutlined: true,
                onPressed: () => context.push('/product-manage/${product.id}'),
              )
            else
              CustomButton(
                text: 'Lihat di Marketplace',
                height: 48.h,
                isOutlined: true,
                onPressed: () => context.push('/product/${product.id}'),
              ),
            SizedBox(height: 8.h),
            CustomButton(
              text: 'Kembali ke Chat',
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
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
          SizedBox(width: 12.w),
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
                  'ID: ${product.id.substring(0, 8)}...',
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
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
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
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
