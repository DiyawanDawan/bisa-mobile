import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_preview_entity.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/create_invoice_cubit.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_breakdown_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_negotiation_shipping_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_shipping_edit_card.dart';
import 'package:mobile_bisa/features/orders/presentation/bloc/order_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class CreateInvoicePage extends StatefulWidget {
  final String negotiationId;

  const CreateInvoicePage({super.key, required this.negotiationId});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _specsController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  bool _termsInitialized = false;

  @override
  void dispose() {
    _specsController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _syncTermControllers(InvoicePreviewEntity preview) {
    if (_termsInitialized) return;
    _qtyController.text = preview.quantity.toStringAsFixed(0);
    _priceController.text = preview.pricePerUnit.toStringAsFixed(0);
    _termsInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<CreateInvoiceCubit>()..loadPreview(widget.negotiationId),
        ),
        BlocProvider(create: (_) => sl<OrderCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'Buat Tagihan',
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [
            BlocBuilder<CreateInvoiceCubit, CreateInvoiceState>(
              builder: (context, state) {
                final exportPreview = state.previewWithDraft;
                if (exportPreview == null) return const SizedBox.shrink();
                return IconButton(
                  tooltip: 'Export PDF',
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: state.status == CreateInvoiceStatus.submitting
                      ? null
                      : () => InvoiceExportHelper.exportPreview(
                            context,
                            exportPreview,
                          ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<CreateInvoiceCubit, CreateInvoiceState>(
          listener: (context, state) {
            if (state.status == CreateInvoiceStatus.loaded &&
                state.draft != null &&
                _specsController.text.isEmpty) {
              _specsController.text = state.draft!.specifications;
            }
            if (state.status == CreateInvoiceStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tagihan berhasil diterbitkan'),
                  backgroundColor: AppColors.secondary,
                ),
              );
              context.pop(true);
            } else if (state.status == CreateInvoiceStatus.error &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == CreateInvoiceStatus.loading ||
                state.status == CreateInvoiceStatus.initial) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 88),
              );
            }

            if (state.status == CreateInvoiceStatus.error &&
                state.preview == null) {
              return _errorState(state.errorMessage ?? 'Gagal memuat preview');
            }

            final preview = state.preview;
            final draft = state.draft;
            if (preview == null || draft == null) {
              return _errorState('Data preview tidak tersedia');
            }

            final buyerLabel =
                preview.buyerCompanyName ?? preview.buyerName;
            final isSubmitting =
                state.status == CreateInvoiceStatus.submitting;
            final exportPreview = state.previewWithDraft!;
            _syncTermControllers(preview);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _headerCard(preview, buyerLabel),
                        SizedBox(height: 14.h),
                        _sectionTitle('Ringkasan Kesepakatan'),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                label: 'Jumlah (${preview.productUnit})',
                                hint: 'Sesuaikan jumlah sebelum terbit',
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  final qty = double.tryParse(v);
                                  if (qty == null) return;
                                  final cubit = context.read<CreateInvoiceCubit>();
                                  cubit.updateDraft(draft.copyWith(quantity: qty));
                                  cubit.refreshPreview(widget.negotiationId);
                                },
                              ),
                              SizedBox(height: 12.h),
                              CustomTextField(
                                label: 'Harga per ${preview.productUnit}',
                                hint: 'Sesuaikan harga sebelum terbit',
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  final price = double.tryParse(v);
                                  if (price == null) return;
                                  final cubit = context.read<CreateInvoiceCubit>();
                                  cubit.updateDraft(draft.copyWith(pricePerUnit: price));
                                  cubit.refreshPreview(widget.negotiationId);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        InvoiceBreakdownCard(
                          title: 'Rincian Tagihan',
                          subtotal: exportPreview.subtotal,
                          platformFee: exportPreview.platformFee,
                          logisticsFee: exportPreview.logisticsFee,
                          vatAmount: exportPreview.vatAmount,
                          totalAmount: exportPreview.totalAmount,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceNegotiationShippingCard(
                          negotiationId: widget.negotiationId,
                          preview: preview,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceShippingEditCard(
                          draft: draft,
                          hintText: 'Dapat disesuaikan sebelum & sesudah tagihan diterbitkan',
                          onChanged: (updated) {
                            context.read<CreateInvoiceCubit>().updateDraft(updated);
                          },
                        ),
                        SizedBox(height: 14.h),
                        _sectionTitle('Catatan / Spesifikasi'),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: CustomTextField(
                            label: 'Ketentuan tambahan tagihan',
                            hint: 'Contoh: kadar air max 12%, pengiriman FOB Surabaya',
                            controller: _specsController,
                            maxLines: 4,
                            onChanged: (v) {
                              context
                                  .read<CreateInvoiceCubit>()
                                  .updateDraft(draft.copyWith(specifications: v));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppColors.grey200)),
                  ),
                  child: Column(
                    children: [
                      CustomButton(
                        text: isSubmitting
                            ? 'Menerbitkan...'
                            : 'Terbitkan Tagihan',
                        useGradient: true,
                        height: 50.h,
                        onPressed: isSubmitting
                            ? null
                            : () => context
                                .read<CreateInvoiceCubit>()
                                .issueInvoice(widget.negotiationId),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Setelah diterbitkan, tagihan masih bisa diedit sebelum pembayaran',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomButton(
                        text: 'Export PDF',
                        height: 46.h,
                        isOutlined: true,
                        onPressed: isSubmitting
                            ? null
                            : () => InvoiceExportHelper.exportPreview(
                                  context,
                                  exportPreview,
                                ),
                      ),
                      SizedBox(height: 8.h),
                      CustomButton(
                        text: 'Kirim PDF ke Chat',
                        height: 46.h,
                        isOutlined: true,
                        onPressed: isSubmitting
                            ? null
                            : () => InvoiceExportHelper.sendPreviewToChat(
                                  context,
                                  widget.negotiationId,
                                  exportPreview,
                                ),
                      ),
                      SizedBox(height: 8.h),
                      CustomButton(
                        text: 'Kembali ke Chat',
                        height: 46.h,
                        isOutlined: true,
                        onPressed: isSubmitting ? null : () => context.pop(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _headerCard(InvoicePreviewEntity preview, String buyerLabel) {
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
            borderRadius: BorderRadius.circular(10.r),
            child: hasResolvableMediaUrl(preview.productThumbnailUrl)
                ? BisaNetworkImage(
                    imageUrl: preview.productThumbnailUrl!,
                    width: 52.w,
                    height: 52.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 52.w,
                    height: 52.w,
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
                  preview.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Pembeli: $buyerLabel',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Tawaran Diterima',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
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

  Widget _errorState(String message) {
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
