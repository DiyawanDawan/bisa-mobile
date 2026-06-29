import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_data.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/review_invoice_cubit.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_breakdown_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_shipping_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_status_banner.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/injection_container.dart';
import '../../../stretch/data/datasources/stretch_remote_data_source.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_avatar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utils/contract_verify_url.dart';
import 'package:url_launcher/url_launcher.dart';

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
        title: 'invoice.review_title'.tr(),
        backgroundColor: AppColors.surface,
        centerTitle: false,
        actions: [
          BlocBuilder<ReviewInvoiceCubit, ReviewInvoiceState>(
            builder: (context, state) {
              final order = state.order;
              if (order == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'invoice.export_tooltip'.tr(),
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
                padding: EdgeInsets.all(AppSpacing.md),
                child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 88),
              );
            }

            if (state.status == ReviewInvoiceStatus.error) {
              return _errorState(
                context,
                localizeFailureMessage(
                  state.errorMessage ?? 'invoice.error_load',
                ),
              );
            }

            final order = state.order;
            if (order == null) {
              return _errorState(context, 'invoice.error_not_found'.tr());
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
                    padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InvoiceStatusBanner(
                          title: isSupplier
                              ? 'invoice.status_issued_supplier'.tr()
                              : 'invoice.status_pending_buyer'.tr(),
                          subtitle: isSupplier
                              ? 'invoice.status_subtitle_supplier'.tr()
                              : 'invoice.status_subtitle_buyer'.tr(),
                        ),
                        SizedBox(height: AppSpacing.section),
                        _sectionTitle('invoice.parties_title'.tr()),
                        SizedBox(height: AppSpacing.sm),
                        _partyCard(
                          title: 'invoice.supplier_label'.tr(),
                          name: order.seller.name,
                          email: order.seller.email,
                          avatarUrl: order.seller.avatarUrl,
                          fallbackIcon: LucideIcons.store,
                          accent: AppColors.primary,
                          isVerified: order.seller.isVerified,
                        ),
                        SizedBox(height: AppSpacing.sm10),
                        _partyCard(
                          title: 'invoice.buyer_label'.tr(),
                          name: order.buyer.name,
                          email: order.buyer.email,
                          avatarUrl: order.buyer.avatarUrl,
                          fallbackIcon: LucideIcons.user,
                          accent: AppColors.info,
                          isVerified: order.buyer.isVerified,
                        ),
                        SizedBox(height: AppSpacing.sm10),
                        _orderNumberRow(order.orderNumber),
                        SizedBox(height: AppSpacing.section),
                        if (product != null) ...[
                          _sectionTitle('invoice.product_detail_title'.tr()),
                          SizedBox(height: AppSpacing.sm),
                          _infoCard([
                            _infoRow('invoice.label_product'.tr(), product.productName),
                            _infoRow(
                              'invoice.label_qty'.tr(),
                              '${product.quantity.toStringAsFixed(0)} ${InvoicePdfData.displayUnit(product.productUnit)}',
                            ),
                            _infoRow('invoice.label_price_unit'.tr(), formatMoneyIdr(product.pricePerUnit)),
                          ]),
                          SizedBox(height: AppSpacing.section),
                        ],
                        InvoiceBreakdownCard(
                          title: 'invoice.breakdown_title'.tr(),
                          subtotal: order.subtotal,
                          platformFee: order.platformFee,
                          logisticsFee: order.logisticsFee,
                          vatAmount: order.vatAmount,
                          totalAmount: order.totalAmount,
                        ),
                        SizedBox(height: AppSpacing.section),
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
                          SizedBox(height: AppSpacing.section),
                          _sectionTitle('invoice.label_notes'.tr()),
                          SizedBox(height: AppSpacing.sm),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSpacing.section),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.tile),
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
                        SizedBox(height: AppSpacing.section),
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

  Widget _signatureStatus(OrderEntity order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: order.isDigitalSigned ? AppColors.success.withValues(alpha: 0.08) : AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: order.isDigitalSigned ? AppColors.success.withValues(alpha: 0.3) : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        order.isDigitalSigned
            ? 'invoice.contract_fully_signed'.tr()
            : 'invoice.contract_pending_signature'.tr(),
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _signContract(BuildContext context, String negotiationId, String orderId) async {
    try {
      await sl<StretchRemoteDataSource>().signOrderContract(orderId);
      if (!context.mounted) return;
      showSuccessSnackBar(context, 'invoice.contract_signed'.tr());
      context.read<ReviewInvoiceCubit>().load(negotiationId);
    } catch (_) {
      if (context.mounted) {
        showErrorSnackBar(context, 'errors.generic'.tr());
      }
    }
  }

  Widget _qrSection(OrderEntity order) {
    final qrData = ContractVerifyUrl.verify(order.orderNumber);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Text(
            'invoice.contract_title'.tr(),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            order.orderNumber,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md12),
          QrImageView(
            data: qrData,
            size: 120.w,
            backgroundColor: AppColors.surface,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'invoice.contract_qr_hint'.tr(),
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(qrData);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text('invoice.action_open_verify'.tr()),
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
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BisaAvatar(
            imageUrl: avatarUrl,
            radius: AppRadius.pill,
            fallbackIcon: fallbackIcon,
            backgroundColor: accent.withValues(alpha: 0.1),
          ),
          SizedBox(width: AppSpacing.md12),
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
            'invoice.label_invoice_number'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
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
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
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
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.grey200)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: AppSpacing.md12),
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!order.isDigitalSigned) ...[
                _signatureStatus(order),
                SizedBox(height: AppSpacing.sm),
                if ((isSupplier && order.sellerSignedAt == null) ||
                    (!isSupplier && order.buyerSignedAt == null))
                  CustomButton(
                    text: 'invoice.action_sign_contract'.tr(),
                    height: 44.h,
                    useGradient: true,
                    onPressed: () => _signContract(context, negotiationId, order.id),
                  ),
                if ((isSupplier && order.sellerSignedAt == null) ||
                    (!isSupplier && order.buyerSignedAt == null))
                  SizedBox(height: AppSpacing.sm),
              ],
              if (!isSupplier && canPay && order.isDigitalSigned)
                CustomButton(
                  text: 'invoice.action_agree_pay'.tr(),
                  useGradient: true,
                  height: 48.h,
                  onPressed: () => context.push(
                    '/order/${order.id}',
                    extra: {'autoPay': true},
                  ),
                )
              else if (!isSupplier)
                CustomButton(
                  text: 'invoice.payment_processed'.tr(),
                  height: 48.h,
                  onPressed: null,
                ),
              if (!isSupplier && canPay) SizedBox(height: AppSpacing.sm),
              if (isSupplier && canPay) ...[
                CustomButton(
                  text: 'invoice.action_edit'.tr(),
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
                SizedBox(height: AppSpacing.sm),
              ],
              CustomButton(
                text: 'invoice.action_download_pdf'.tr(),
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
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm10),
                  minimumSize: Size(double.infinity, 40.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'invoice.action_back_to_chat'.tr(),
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
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.md12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.md),
            CustomButton(
              text: 'invoice.action_back'.tr(),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
