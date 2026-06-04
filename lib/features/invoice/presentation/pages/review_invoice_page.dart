import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_data.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/review_invoice_cubit.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_breakdown_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_shipping_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_status_banner.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_avatar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReviewInvoicePage extends StatelessWidget {
  final String negotiationId;

  const ReviewInvoicePage({super.key, required this.negotiationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewInvoiceCubit>()..load(negotiationId),
      child: _ReviewInvoiceBody(negotiationId: negotiationId),
    );
  }
}

class _ReviewInvoiceBody extends StatelessWidget {
  final String negotiationId;

  const _ReviewInvoiceBody({required this.negotiationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'Review Tagihan',
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          BlocBuilder<ReviewInvoiceCubit, ReviewInvoiceState>(
            builder: (context, state) {
              final order = state.order;
              if (order == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Export PDF',
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: () => InvoiceExportHelper.exportOrder(context, order),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ReviewInvoiceCubit, ReviewInvoiceState>(
          builder: (context, state) {
            if (state.status == ReviewInvoiceStatus.loading ||
                state.status == ReviewInvoiceStatus.initial) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 88),
              );
            }

            if (state.status == ReviewInvoiceStatus.error) {
              return _errorState(
                context,
                state.errorMessage ?? 'Gagal memuat tagihan',
              );
            }

            final order = state.order;
            if (order == null) {
              return _errorState(context, 'Data tagihan tidak ditemukan');
            }

            final product = order.items.isNotEmpty ? order.items.first : null;
            final canPay = order.status == 'PENDING';
            final isSupplier = context.read<AuthCubit>().state.maybeWhen(
                  authenticated: (user) => user.role == 'SUPPLIER',
                  orElse: () => false,
                );

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InvoiceStatusBanner(
                          title: isSupplier
                              ? 'Tagihan Diterbitkan'
                              : 'Menunggu Pembayaran',
                          subtitle: isSupplier
                              ? 'Tagihan sudah dikirim. Edit jika ada typo sebelum pembeli bayar.'
                              : 'Periksa rincian tagihan dari supplier. Lanjutkan jika sudah sesuai.',
                        ),
                        SizedBox(height: 14.h),
                        _sectionTitle('Pihak Tagihan'),
                        SizedBox(height: 8.h),
                        _partyCard(
                          title: 'Supplier (Penjual)',
                          name: order.seller.name,
                          email: order.seller.email,
                          avatarUrl: order.seller.avatarUrl,
                          fallbackIcon: LucideIcons.store,
                          accent: AppColors.primary,
                          isVerified: order.seller.isVerified,
                        ),
                        SizedBox(height: 10.h),
                        _partyCard(
                          title: 'Pembeli',
                          name: order.buyer.name,
                          email: order.buyer.email,
                          avatarUrl: order.buyer.avatarUrl,
                          fallbackIcon: LucideIcons.user,
                          accent: AppColors.info,
                          isVerified: order.buyer.isVerified,
                        ),
                        SizedBox(height: 10.h),
                        _orderNumberRow(order.orderNumber),
                        SizedBox(height: 14.h),
                        if (product != null) ...[
                          _sectionTitle('Detail Produk'),
                          SizedBox(height: 8.h),
                          _infoCard([
                            _infoRow('Produk', product.productName),
                            _infoRow(
                              'Jumlah',
                              '${product.quantity.toStringAsFixed(0)} ${InvoicePdfData.displayUnit(product.productUnit)}',
                            ),
                            _infoRow('Harga/Unit', product.pricePerUnit.toRupiah),
                          ]),
                          SizedBox(height: 14.h),
                        ],
                        InvoiceBreakdownCard(
                          title: 'Rincian Tagihan',
                          subtotal: order.subtotal,
                          platformFee: order.platformFee,
                          logisticsFee: order.logisticsFee,
                          vatAmount: order.vatAmount,
                          totalAmount: order.totalAmount,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceShippingCard(
                          snapshot: order.shippingAddressSnapshot,
                          originSnapshot: InvoicePdfData.originFromSnapshot(
                            order.shippingAddressSnapshot,
                          ),
                          sellerOriginLabel: InvoicePdfData.originLabelFromSnapshot(
                                order.shippingAddressSnapshot,
                              ) ??
                              order.orderShipping?.originLabel,
                          orderShipping: order.orderShipping,
                        ),
                        if (order.specifications != null &&
                            order.specifications!.isNotEmpty) ...[
                          SizedBox(height: 14.h),
                          _sectionTitle('Catatan'),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Text(
                              order.specifications!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 14.h),
                        _qrSection(order),
                      ],
                    ),
                  ),
                ),
                _buildActionFooter(
                  context,
                  isSupplier: isSupplier,
                  canPay: canPay,
                  negotiationId: negotiationId,
                  order: order,
                ),
              ],
            );
          },
      ),
    );
  }

  Widget _qrSection(OrderEntity order) {
    final qrData = '${order.orderNumber}:PENDING:${order.createdAt.millisecondsSinceEpoch}';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Text(
            'Kontrak Digital',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            order.orderNumber,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          QrImageView(
            data: qrData,
            size: 120.w,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  /// Kartu pihak tagihan (Supplier/Pembeli) dengan nama + email + badge verif.
  /// Email ditampilkan eksplisit di tagihan agar kedua pihak punya jejak
  /// kontak resmi dari B2B order ini.
  Widget _partyCard({
    required String title,
    required String name,
    required IconData fallbackIcon,
    required Color accent,
    String? email,
    String? avatarUrl,
    bool isVerified = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BisaAvatar(
            imageUrl: avatarUrl,
            radius: 20.r,
            fallbackIcon: fallbackIcon,
            backgroundColor: accent.withValues(alpha: 0.1),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        LucideIcons.badgeCheck,
                        size: 12.sp,
                        color: AppColors.info,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (email != null && email.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.mail,
                        size: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderNumberRow(String orderNumber) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.hash,
            size: 14.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 6.w),
          Text(
            'No. Tagihan',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              orderNumber,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(
    BuildContext context, {
    required bool isSupplier,
    required bool canPay,
    required String negotiationId,
    required OrderEntity order,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isSupplier && canPay)
                CustomButton(
                  text: 'Setuju & Lanjut Bayar',
                  useGradient: true,
                  height: 48.h,
                  onPressed: () => context.push('/order/${order.id}'),
                )
              else if (!isSupplier)
                CustomButton(
                  text: 'Tagihan Sudah Diproses',
                  height: 48.h,
                  onPressed: null,
                ),
              if (!isSupplier && canPay) SizedBox(height: 8.h),
              if (isSupplier && canPay) ...[
                CustomButton(
                  text: 'Edit Tagihan',
                  height: 44.h,
                  isOutlined: true,
                  onPressed: () async {
                    final updated = await context.push<bool>(
                      '/negotiation/$negotiationId/edit-invoice',
                    );
                    if (updated == true && context.mounted) {
                      context.read<ReviewInvoiceCubit>().load(negotiationId);
                    }
                  },
                ),
                SizedBox(height: 8.h),
              ],
              CustomButton(
                text: 'Download PDF',
                height: 44.h,
                isOutlined: true,
                onPressed: () =>
                    InvoiceExportHelper.exportOrder(context, order),
              ),
              SizedBox(height: 4.h),
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  minimumSize: Size(double.infinity, 40.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Kembali ke Chat',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 16.h),
            CustomButton(
              text: 'Kembali',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
