import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_draft.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_data.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/edit_invoice_cubit.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_breakdown_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_shipping_edit_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_status_banner.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_issue_checklist_card.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class EditInvoicePage extends StatefulWidget {
  final String negotiationId;

  const EditInvoicePage({super.key, required this.negotiationId});

  @override
  State<EditInvoicePage> createState() => _EditInvoicePageState();
}

class _EditInvoicePageState extends State<EditInvoicePage> {
  final _specsController = TextEditingController();

  @override
  void dispose() {
    _specsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditInvoiceCubit>()..load(widget.negotiationId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'Edit Tagihan',
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [
            BlocBuilder<EditInvoiceCubit, EditInvoiceState>(
              builder: (context, state) {
                final order = state.order;
                final draft = state.draft;
                if (order == null || draft == null) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  tooltip: 'Export PDF',
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: state.status == EditInvoiceStatus.submitting
                      ? null
                      : () => InvoiceExportHelper.exportPdfData(
                            context,
                            InvoicePdfData.fromOrderDraft(order, draft),
                          ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<EditInvoiceCubit, EditInvoiceState>(
          listener: (context, state) {
            if (state.status == EditInvoiceStatus.loaded &&
                state.draft != null &&
                _specsController.text.isEmpty) {
              _specsController.text = state.draft!.specifications;
            }
            if (state.status == EditInvoiceStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tagihan berhasil diperbarui'),
                  backgroundColor: AppColors.secondary,
                ),
              );
              context.pop(true);
            } else if (state.status == EditInvoiceStatus.error &&
                state.errorMessage != null &&
                state.order != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == EditInvoiceStatus.loading ||
                state.status == EditInvoiceStatus.initial) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 88),
              );
            }

            if (state.status == EditInvoiceStatus.error && state.order == null) {
              return _errorState(state.errorMessage ?? 'Gagal memuat tagihan');
            }

            final order = state.order;
            final draft = state.draft;
            if (order == null || draft == null) {
              return _errorState('Data tagihan tidak tersedia');
            }

            final product = order.items.isNotEmpty ? order.items.first : null;
            final isSubmitting = state.status == EditInvoiceStatus.submitting;
            final canEdit = state.canEdit;
            final saveReadiness = state.saveReadiness;
            final canSave = saveReadiness.canIssue && !isSubmitting;

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
                          title: canEdit ? 'Perbaiki Tagihan' : 'Tagihan Terkunci',
                          subtitle: canEdit
                              ? 'Perbaiki typo alamat atau catatan sebelum pembeli bayar.'
                              : 'Tagihan sudah diproses dan tidak bisa diubah lagi.',
                          color: canEdit ? AppColors.primary : AppColors.textHint,
                        ),
                        SizedBox(height: 14.h),
                        _infoCard([
                          _infoRow('No. Tagihan', order.orderNumber),
                          if (product != null) ...[
                            _infoRow('Produk', product.productName),
                            _infoRow(
                              'Jumlah',
                              '${product.quantity.toStringAsFixed(0)} unit',
                            ),
                          ],
                        ]),
                        SizedBox(height: 14.h),
                        InvoiceBreakdownCard(
                          title: 'Rincian Tagihan',
                          subtotal: order.subtotal,
                          platformFee: order.platformFee,
                          logisticsFee: order.logisticsFee,
                          vatAmount: order.vatAmount,
                          totalAmount: order.totalAmount,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceShippingEditCard(
                          draft: draft,
                          readOnly: !canEdit,
                          hintText: canEdit
                              ? 'Perbaiki alamat jika ada typo sebelum pembeli bayar'
                              : null,
                          onChanged: canEdit
                              ? (updated) {
                                  context
                                      .read<EditInvoiceCubit>()
                                      .updateDraft(updated);
                                }
                              : null,
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'Catatan / Spesifikasi',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                          ),
                        ),
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
                            enabled: canEdit,
                            onChanged: canEdit
                                ? (v) {
                                    context.read<EditInvoiceCubit>().updateDraft(
                                          draft.copyWith(specifications: v),
                                        );
                                  }
                                : null,
                          ),
                        ),
                        if (canEdit) ...[
                          SizedBox(height: 14.h),
                          InvoiceIssueChecklistCard(
                            readiness: saveReadiness,
                            readyText: 'Alamat lengkap — siap disimpan',
                            pendingTitle:
                                'Lengkapi data berikut sebelum simpan',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                _buildActionFooter(
                  context,
                  canEdit: canEdit,
                  canSave: canSave,
                  isSubmitting: isSubmitting,
                  order: order,
                  draft: draft,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionFooter(
    BuildContext context, {
    required bool canEdit,
    required bool canSave,
    required bool isSubmitting,
    required OrderEntity order,
    required InvoiceDraft draft,
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
              if (canEdit) ...[
                CustomButton(
                  text: isSubmitting ? 'Menyimpan...' : 'Simpan Perubahan',
                  useGradient: canSave,
                  height: 48.h,
                  onPressed: canSave
                      ? () => context.read<EditInvoiceCubit>().saveChanges()
                      : null,
                ),
                SizedBox(height: 6.h),
                Text(
                  'Perbaiki typo alamat sebelum pembeli melakukan pembayaran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12.h),
              ],
              CustomButton(
                text: 'Download PDF',
                height: 44.h,
                isOutlined: true,
                onPressed: isSubmitting
                    ? null
                    : () => InvoiceExportHelper.exportPdfData(
                          context,
                          InvoicePdfData.fromOrderDraft(order, draft),
                        ),
              ),
              SizedBox(height: 4.h),
              TextButton(
                onPressed: isSubmitting ? null : () => context.pop(),
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
          Text(label, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
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
            CustomButton(text: 'Kembali', onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}
