import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_draft.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_pdf_data.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/edit_invoice_cubit.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_breakdown_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_deal_economics_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_product_summary_card.dart';
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
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  bool _controllersSeeded = false;

  @override
  void dispose() {
    _specsController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _seedControllers(InvoiceDraft draft) {
    if (_controllersSeeded) return;
    _specsController.text = draft.specifications;
    _qtyController.text = draft.quantity.toStringAsFixed(
      draft.quantity % 1 == 0 ? 0 : 1,
    );
    _priceController.text = draft.pricePerUnit.toStringAsFixed(0);
    _controllersSeeded = true;
  }

  ({double subtotal, double platformFee, double vatAmount, double total})
  _recalcTotals(OrderEntity order, InvoiceDraft draft) {
    final subtotal = draft.quantity * draft.pricePerUnit;
    final base = order.subtotal;
    double platformFee = order.platformFee;
    double vat = order.vatAmount;
    if (base > 0 && subtotal != base) {
      platformFee = subtotal * (order.platformFee / base);
      vat = subtotal * (order.vatAmount / base);
    }
    return (
      subtotal: subtotal,
      platformFee: platformFee,
      vatAmount: vat,
      total: subtotal + platformFee + vat + order.logisticsFee,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditInvoiceCubit>()..load(widget.negotiationId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'invoice.edit_title'.tr(),
          backgroundColor: AppColors.surface,
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
                  tooltip: 'invoice.export_tooltip'.tr(),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: state.status == EditInvoiceStatus.submitting
                      ? null
                      : () => InvoiceExportHelper.exportPdfData(
                          context,
                          InvoicePdfData.fromOrderDraft(order, draft),
                          order: order,
                        ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<EditInvoiceCubit, EditInvoiceState>(
          listener: (context, state) {
            if (state.status == EditInvoiceStatus.loaded &&
                state.draft != null) {
              _seedControllers(state.draft!);
            }
            if (state.status == EditInvoiceStatus.success) {
              showSuccessSnackBar(context, 'invoice.update_success'.tr());
              context.pop(true);
            } else if (state.status == EditInvoiceStatus.error &&
                state.errorMessage != null &&
                state.order != null) {
              showFailureSnackBarFromMessage(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            if (state.status == EditInvoiceStatus.loading ||
                state.status == EditInvoiceStatus.initial) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: const ShimmerListPlaceholder(
                  itemCount: 4,
                  itemHeight: 88,
                ),
              );
            }

            if (state.status == EditInvoiceStatus.error &&
                state.order == null) {
              return _errorState(
                localizeFailureMessage(
                  state.errorMessage ?? 'invoice.error_load',
                ),
              );
            }

            final order = state.order;
            final draft = state.draft;
            if (order == null || draft == null) {
              return _errorState('invoice.error_preview_unavailable'.tr());
            }

            final product = order.items.isNotEmpty ? order.items.first : null;
            final negotiation = state.negotiation;
            final isSubmitting = state.status == EditInvoiceStatus.submitting;
            final canEdit = state.canEdit;
            final saveReadiness = state.saveReadiness;
            final canSave = saveReadiness.canIssue && !isSubmitting;
            final totals = _recalcTotals(order, draft);
            final unit =
                negotiation?.product.unit ?? product?.productUnit ?? 'unit';
            final catalogPrice =
                negotiation?.product.pricePerUnit ?? product?.pricePerUnit;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.pageGutter,
                      AppSpacing.comfortable,
                      AppSpacing.pageGutter,
                      AppSpacing.spacious,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InvoiceStatusBanner(
                          title: canEdit
                              ? 'invoice.edit_banner_fix_title'.tr()
                              : 'invoice.edit_banner_locked_title'.tr(),
                          subtitle: canEdit
                              ? 'invoice.edit_banner_fix_subtitle'.tr()
                              : 'invoice.edit_banner_locked_subtitle'.tr(),
                          color: canEdit
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceProductSummaryCard(
                          invoiceNumber: order.orderNumber,
                          productName:
                              product?.productName ??
                              negotiation?.product.name ??
                              'Produk',
                          quantity: draft.quantity,
                          pricePerUnit: draft.pricePerUnit,
                          unit: unit,
                          thumbnailUrl:
                              product?.thumbnailUrl ??
                              negotiation?.product.thumbnailUrl,
                          catalogPricePerUnit: catalogPrice,
                        ),
                        if (canEdit) ...[
                          SizedBox(height: 14.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Column(
                              children: [
                                CustomTextField(
                                  label: 'invoice.qty_adjust_label'.tr(
                                    namedArgs: {'unit': unit},
                                  ),
                                  hint: 'invoice.qty_adjust_hint'.tr(),
                                  controller: _qtyController,
                                  keyboardType: TextInputType.number,
                                  isRequired: true,
                                  onChanged: (v) {
                                    final qty = double.tryParse(v);
                                    if (qty == null) return;
                                    context
                                        .read<EditInvoiceCubit>()
                                        .updateDraft(
                                          draft.copyWith(quantity: qty),
                                        );
                                  },
                                ),
                                SizedBox(height: 12.h),
                                CustomTextField(
                                  label: 'invoice.price_adjust_label'.tr(
                                    namedArgs: {'unit': unit},
                                  ),
                                  hint: 'invoice.price_adjust_hint'.tr(),
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  isRequired: true,
                                  onChanged: (v) {
                                    final price = double.tryParse(v);
                                    if (price == null) return;
                                    context
                                        .read<EditInvoiceCubit>()
                                        .updateDraft(
                                          draft.copyWith(pricePerUnit: price),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (state.economics != null) ...[
                          SizedBox(height: 14.h),
                          InvoiceDealEconomicsCard(economics: state.economics!),
                        ],
                        SizedBox(height: 14.h),
                        InvoiceBreakdownCard(
                          title: 'invoice.breakdown_title'.tr(),
                          subtotal: totals.subtotal,
                          platformFee: totals.platformFee,
                          logisticsFee: order.logisticsFee,
                          vatAmount: totals.vatAmount,
                          totalAmount: totals.total,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceShippingEditCard(
                          draft: draft,
                          readOnly: !canEdit,
                          hintText: canEdit
                              ? 'invoice.edit_shipping_hint'.tr()
                              : null,
                          onChanged: canEdit
                              ? (updated) {
                                  context.read<EditInvoiceCubit>().updateDraft(
                                    updated,
                                  );
                                }
                              : null,
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'invoice.notes_section'.tr(),
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
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: CustomTextField(
                            label: 'invoice.notes_label'.tr(),
                            hint: 'invoice.notes_hint'.tr(),
                            controller: _specsController,
                            maxLines: 4,
                            enabled: canEdit,
                            isOptional: true,
                            onChanged: canEdit
                                ? (v) {
                                    context
                                        .read<EditInvoiceCubit>()
                                        .updateDraft(
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
                            readyText: 'invoice.issue_save_ready'.tr(),
                            pendingTitle: 'invoice.issue_save_pending'.tr(),
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
        minimum: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canEdit) ...[
                CustomButton(
                  text: isSubmitting
                      ? 'invoice.edit_saving'.tr()
                      : 'invoice.edit_save_button'.tr(),
                  useGradient: canSave,
                  height: 48.h,
                  onPressed: canSave
                      ? () => context.read<EditInvoiceCubit>().saveChanges()
                      : null,
                ),
                SizedBox(height: 6.h),
                Text(
                  'invoice.edit_footer_note'.tr(),
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
                text: 'invoice.action_download_pdf'.tr(),
                height: AppSpacing.buttonHeightSm,
                isOutlined: true,
                onPressed: isSubmitting
                    ? null
                    : () => InvoiceExportHelper.exportPdfData(
                        context,
                        InvoicePdfData.fromOrderDraft(order, draft),
                        order: order,
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

  Widget _infoCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
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

  Widget _errorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacious),
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
              text: 'invoice.action_back'.tr(),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
