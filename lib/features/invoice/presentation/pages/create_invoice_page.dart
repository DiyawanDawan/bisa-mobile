import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_preview_entity.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/create_invoice_cubit.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_breakdown_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_negotiation_shipping_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_buyer_shipping_panel.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_deal_economics_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_shipping_route_overview.dart';
import 'package:mobile_bisa/features/invoice/presentation/widgets/invoice_issue_checklist_card.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_issue_readiness.dart';
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
          title: 'invoice.create_title'.tr(),
          backgroundColor: AppColors.surface,
          centerTitle: false,
          actions: [
            BlocBuilder<CreateInvoiceCubit, CreateInvoiceState>(
              builder: (context, state) {
                final exportPreview = state.previewWithDraft;
                if (exportPreview == null) return const SizedBox.shrink();
                return IconButton(
                  tooltip: 'invoice.export_tooltip'.tr(),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: state.status == CreateInvoiceStatus.submitting
                      ? null
                      : () => InvoiceExportHelper.exportPreview(
                            context,
                            exportPreview,
                            sellerShippingSnapshot:
                                state.sellerShippingSnapshot ??
                                    exportPreview.sellerShippingSnapshot,
                            sellerOriginLabel: state.sellerOriginLabel ??
                                exportPreview.sellerOriginLabel,
                            shippingSelection: state.shippingSelection,
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
              showSuccessSnackBar(context, 'invoice.issue_success'.tr());
              context.pop(true);
            } else if (state.status == CreateInvoiceStatus.error &&
                state.errorMessage != null) {
              showFailureSnackBarFromMessage(context, state.errorMessage!);
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
              return _errorState(
                localizeFailureMessage(
                  state.errorMessage ?? 'invoice.error_load',
                ),
              );
            }

            final preview = state.preview;
            final draft = state.draft;
            if (preview == null || draft == null) {
              return _errorState('invoice.error_preview_unavailable'.tr());
            }

            final buyerLabel =
                preview.buyerCompanyName ?? preview.buyerName;
            final isSubmitting =
                state.status == CreateInvoiceStatus.submitting;
            final exportPreview = state.previewWithDraft!;
            final cubit = context.read<CreateInvoiceCubit>();
            final readiness = cubit.issueReadiness;
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
                        _sectionTitle('invoice.deal_summary'.tr()),
                        SizedBox(height: 8.h),
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
                                  namedArgs: {'unit': preview.productUnit},
                                ),
                                hint: 'invoice.qty_adjust_hint'.tr(),
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                isRequired: true,
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
                                label: 'invoice.price_adjust_label'.tr(
                                  namedArgs: {'unit': preview.productUnit},
                                ),
                                hint: 'invoice.price_adjust_hint'.tr(),
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                isRequired: true,
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
                        if (exportPreview.economics != null) ...[
                          SizedBox(height: 14.h),
                          InvoiceDealEconomicsCard(
                            economics: exportPreview.economics!,
                          ),
                        ],
                        SizedBox(height: 14.h),
                        _sectionTitle('invoice.shipping_section'.tr()),
                        SizedBox(height: 8.h),
                        InvoiceShippingRouteOverview(
                          sellerSnapshot: state.sellerShippingSnapshot ??
                              exportPreview.sellerShippingSnapshot,
                          buyerDraft: draft,
                          sellerOriginLabel: state.sellerOriginLabel ??
                              exportPreview.sellerOriginLabel,
                          sellerOriginResolved: (state.sellerOriginId ??
                                  exportPreview.sellerOriginId) !=
                              null,
                        ),
                        SizedBox(height: 12.h),
                        _sectionTitle('invoice.buyer_shipping_title'.tr()),
                        SizedBox(height: 8.h),
                        InvoiceBuyerShippingPanel(
                          negotiationId: widget.negotiationId,
                          draft: draft,
                          onDraftChanged: (updated) async {
                            final cubit = context.read<CreateInvoiceCubit>();
                            final shouldRefresh = cubit.updateDraft(updated);
                            if (shouldRefresh) {
                              await cubit.refreshPreview(widget.negotiationId);
                            }
                          },
                        ),
                        SizedBox(height: 14.h),
                        InvoiceNegotiationShippingCard(
                          negotiationId: widget.negotiationId,
                        ),
                        SizedBox(height: 14.h),
                        InvoiceBreakdownCard(
                          title: 'invoice.breakdown_title'.tr(),
                          subtotal: exportPreview.subtotal,
                          platformFee: exportPreview.platformFee,
                          logisticsFee: exportPreview.logisticsFee,
                          vatAmount: exportPreview.vatAmount,
                          totalAmount: exportPreview.totalAmount,
                        ),
                        SizedBox(height: 14.h),
                        _sectionTitle('invoice.notes_section'.tr()),
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
                            isOptional: true,
                            onChanged: (v) {
                              context
                                  .read<CreateInvoiceCubit>()
                                  .updateDraft(draft.copyWith(specifications: v));
                            },
                          ),
                        ),
                        SizedBox(height: 14.h),
                        InvoiceIssueChecklistCard(readiness: readiness),
                      ],
                    ),
                  ),
                ),
                _buildActionFooter(
                  context,
                  state: state,
                  isSubmitting: isSubmitting,
                  exportPreview: exportPreview,
                  readiness: readiness,
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
    required CreateInvoiceState state,
    required bool isSubmitting,
    required InvoicePreviewEntity exportPreview,
    required InvoiceIssueReadiness readiness,
  }) {
    final canIssue = readiness.canIssue && !isSubmitting;
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
              CustomButton(
                text: isSubmitting
                    ? 'invoice.issue_updating'.tr()
                    : 'invoice.issue_button'.tr(),
                useGradient: canIssue,
                height: 48.h,
                onPressed: canIssue
                    ? () => context
                        .read<CreateInvoiceCubit>()
                        .issueInvoice(widget.negotiationId)
                    : null,
              ),
              SizedBox(height: 6.h),
              Text(
                'invoice.issue_footer_note'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textHint,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'invoice.action_export_pdf'.tr(),
                      height: 44.h,
                      isOutlined: true,
                      onPressed: isSubmitting
                          ? null
                          : () => InvoiceExportHelper.exportPreview(
                                context,
                                exportPreview,
                                sellerShippingSnapshot:
                                    state.sellerShippingSnapshot ??
                                        exportPreview.sellerShippingSnapshot,
                                sellerOriginLabel: state.sellerOriginLabel ??
                                    exportPreview.sellerOriginLabel,
                                shippingSelection: state.shippingSelection,
                              ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      text: 'invoice.action_send_to_chat'.tr(),
                      height: 44.h,
                      isOutlined: true,
                      onPressed: isSubmitting
                          ? null
                          : () => InvoiceExportHelper.sendPreviewToChat(
                                context,
                                widget.negotiationId,
                                exportPreview,
                              ),
                    ),
                  ),
                ],
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
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

  Widget _headerCard(InvoicePreviewEntity preview, String buyerLabel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                    'invoice.status_accepted_badge'.tr(),
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
              text: 'invoice.action_back'.tr(),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
