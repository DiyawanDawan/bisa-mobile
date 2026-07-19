import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/partnership_cubit.dart';
import '../utils/partnership_pdf_export_helper.dart';
import '../../data/services/partnership_pdf_service.dart';

class PartnershipCreatePage extends StatefulWidget {
  final String supplierId;
  final String supplierName;
  final String? negotiationId;

  const PartnershipCreatePage({
    super.key,
    required this.supplierId,
    required this.supplierName,
    this.negotiationId,
  });

  @override
  State<PartnershipCreatePage> createState() => _PartnershipCreatePageState();
}

class _PartnershipCreatePageState extends State<PartnershipCreatePage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _deliveryCtrl = TextEditingController();
  final _paymentCtrl = TextEditingController();
  final _specialCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  late DateTime _endDate = DateTime.now().add(const Duration(days: 365));
  String? _error;
  bool _sendToChatAfterCreate = true;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _categoryCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    _deliveryCtrl.dispose();
    _paymentCtrl.dispose();
    _specialCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (!_endDate.isAfter(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 365));
        }
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _downloadDraft(BuildContext context) async {
    if (_titleCtrl.text.trim().length < 5) {
      setState(() => _error = 'partnership.form_invalid'.tr());
      return;
    }
    if (_endDate.isBefore(_startDate) || _endDate.isAtSameMomentAs(_startDate)) {
      setState(() => _error = 'partnership.date_invalid'.tr());
      return;
    }
    setState(() => _error = null);

    final qty = _qtyCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_qtyCtrl.text.trim());

    await PartnershipPdfExportHelper.exportDraftForm(
      context,
      title: _titleCtrl.text.trim(),
      supplierName: widget.supplierName,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      productCategory:
          _categoryCtrl.text.trim().isEmpty ? null : _categoryCtrl.text.trim(),
      estimatedMonthlyQty: qty != null && qty > 0 ? qty : null,
      priceAgreement:
          _priceCtrl.text.trim().isEmpty ? null : _priceCtrl.text.trim(),
      deliveryTerms:
          _deliveryCtrl.text.trim().isEmpty ? null : _deliveryCtrl.text.trim(),
      paymentTerms:
          _paymentCtrl.text.trim().isEmpty ? null : _paymentCtrl.text.trim(),
      specialTerms:
          _specialCtrl.text.trim().isEmpty ? null : _specialCtrl.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Future<void> _sendDraftToChat(BuildContext context) async {
    final negotiationId = widget.negotiationId;
    if (negotiationId == null || negotiationId.isEmpty) return;

    if (_titleCtrl.text.trim().length < 5) {
      setState(() => _error = 'partnership.form_invalid'.tr());
      return;
    }
    if (_endDate.isBefore(_startDate) || _endDate.isAtSameMomentAs(_startDate)) {
      setState(() => _error = 'partnership.date_invalid'.tr());
      return;
    }
    setState(() => _error = null);

    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null) return;

    final qty = _qtyCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_qtyCtrl.text.trim());

    final draft = PartnershipPdfData.fromDraftForm(
      title: _titleCtrl.text.trim(),
      buyerName: user.name,
      buyerCompany: user.companyName,
      supplierName: widget.supplierName,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      productCategory:
          _categoryCtrl.text.trim().isEmpty ? null : _categoryCtrl.text.trim(),
      estimatedMonthlyQty: qty != null && qty > 0 ? qty : null,
      priceAgreement:
          _priceCtrl.text.trim().isEmpty ? null : _priceCtrl.text.trim(),
      deliveryTerms:
          _deliveryCtrl.text.trim().isEmpty ? null : _deliveryCtrl.text.trim(),
      paymentTerms:
          _paymentCtrl.text.trim().isEmpty ? null : _paymentCtrl.text.trim(),
      specialTerms:
          _specialCtrl.text.trim().isEmpty ? null : _specialCtrl.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
    );

    await PartnershipPdfExportHelper.showSendProposalSheet(
      context,
      negotiationId: negotiationId,
      draftData: draft,
      counterpartyName: widget.supplierName,
    );
  }

  Future<void> _submit(BuildContext context) async {
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null || user.role == 'SUPPLIER') {
      setState(() => _error = 'partnership.buyer_only'.tr());
      return;
    }

    final qty = _qtyCtrl.text.trim().isEmpty ? null : double.tryParse(_qtyCtrl.text.trim());
    if (_titleCtrl.text.trim().length < 5) {
      setState(() => _error = 'partnership.form_invalid'.tr());
      return;
    }
    if (_endDate.isBefore(_startDate) || _endDate.isAtSameMomentAs(_startDate)) {
      setState(() => _error = 'partnership.date_invalid'.tr());
      return;
    }

    setState(() => _error = null);

    final body = {
      'supplierId': widget.supplierId,
      'title': _titleCtrl.text.trim(),
      if (_descCtrl.text.trim().isNotEmpty) 'description': _descCtrl.text.trim(),
      if (_categoryCtrl.text.trim().isNotEmpty) 'productCategory': _categoryCtrl.text.trim(),
      if (qty != null && qty > 0) 'estimatedMonthlyQty': qty,
      if (_priceCtrl.text.trim().isNotEmpty) 'priceAgreement': _priceCtrl.text.trim(),
      if (_deliveryCtrl.text.trim().isNotEmpty) 'deliveryTerms': _deliveryCtrl.text.trim(),
      if (_paymentCtrl.text.trim().isNotEmpty) 'paymentTerms': _paymentCtrl.text.trim(),
      if (_specialCtrl.text.trim().isNotEmpty) 'specialTerms': _specialCtrl.text.trim(),
      'startDate': _startDate.toIso8601String(),
      'endDate': _endDate.toIso8601String(),
      'tier': 'MAIN_PARTNER',
    };

    final cubit = context.read<PartnershipCubit>();
    try {
      final err = await cubit.createPartnership(body);
      if (!mounted) return;
      if (err != null) {
        setState(() => _error = err.localizedFailure);
        return;
      }
      showSuccessSnackBar(context, 'partnership.create_success'.tr());
      final created = cubit.state.selected;
      final negotiationId = widget.negotiationId;
      if (created != null &&
          negotiationId != null &&
          negotiationId.isNotEmpty &&
          _sendToChatAfterCreate) {
        await PartnershipPdfExportHelper.sendEntityToChat(
          context,
          partnership: created,
          negotiationId: negotiationId,
          openChatAfter: true,
        );
        return;
      }
      final id = created?.id;
      if (id != null) {
        context.go('/partnerships/$id');
      } else {
        context.pop(true);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _error = dioExceptionToFailure(e).message.localizedFailure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');

    return BlocProvider(
      create: (_) => sl<PartnershipCubit>()..checkSupplier(widget.supplierId),
      child: BlocBuilder<PartnershipCubit, PartnershipState>(
        builder: (context, state) {
          final existing = state.supplierCheck;
          if (existing != null &&
              existing.status != 'EXPIRED' &&
              existing.status != 'TERMINATED' &&
              existing.status != 'REJECTED') {
            return Scaffold(
              appBar: BisaAppBar(title: 'partnership.create_title'.tr()),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.handshake, size: 48.sp, color: AppColors.warning),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'partnership.already_exists'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      CustomButton(
                        text: 'partnership.view_existing'.tr(),
                        onPressed: () => context.go('/partnerships/${existing.id}'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (existing != null && existing.status == 'EXPIRED') {
            return Scaffold(
              appBar: BisaAppBar(title: 'partnership.create_title'.tr()),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.calendarClock, size: 48.sp, color: AppColors.warning),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'partnership.expired_renew_hint'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      CustomButton(
                        text: 'partnership.renew_contract'.tr(),
                        onPressed: () => context.go('/partnerships/${existing.id}'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              backgroundColor: AppColors.surface,
              title: 'partnership.create_title'.tr(),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoBanner(supplierName: widget.supplierName),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'partnership.required_legend'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    controller: _titleCtrl,
                    label: 'partnership.field_title'.tr(),
                    hint: 'partnership.field_title_hint'.tr(),
                    isRequired: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _descCtrl,
                    label: 'partnership.field_description'.tr(),
                    hint: 'partnership.field_description_hint'.tr(),
                    maxLines: 3,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _categoryCtrl,
                    label: 'partnership.field_category'.tr(),
                    hint: 'partnership.field_category_hint'.tr(),
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _qtyCtrl,
                    label: 'partnership.field_qty'.tr(),
                    hint: '100',
                    keyboardType: TextInputType.number,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _priceCtrl,
                    label: 'partnership.field_price'.tr(),
                    hint: 'partnership.field_price_hint'.tr(),
                    maxLines: 2,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _deliveryCtrl,
                    label: 'partnership.field_delivery'.tr(),
                    hint: '${'partnership.field_delivery'.tr()}...',
                    maxLines: 2,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _paymentCtrl,
                    label: 'partnership.field_payment'.tr(),
                    hint: '${'partnership.field_payment'.tr()}...',
                    maxLines: 2,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  CustomTextField(
                    controller: _specialCtrl,
                    label: 'partnership.field_special'.tr(),
                    hint: '${'partnership.field_special'.tr()}...',
                    maxLines: 2,
                    isOptional: true,
                  ),
                  SizedBox(height: AppSpacing.md12),
                  _DateRow(
                    label: 'partnership.field_start'.tr(),
                    value: dateFmt.format(_startDate),
                    onTap: () => _pickDate(isStart: true),
                    isRequired: true,
                  ),
                  SizedBox(height: AppSpacing.sm10),
                  _DateRow(
                    label: 'partnership.field_end'.tr(),
                    value: dateFmt.format(_endDate),
                    onTap: () => _pickDate(isStart: false),
                    isRequired: true,
                  ),
                  if (_error != null) ...[
                    SizedBox(height: AppSpacing.md),
                    Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13.sp)),
                  ],
                  SizedBox(height: AppSpacing.xl),
                  if (widget.negotiationId != null) ...[
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _sendToChatAfterCreate,
                      onChanged: (v) =>
                          setState(() => _sendToChatAfterCreate = v ?? true),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'partnership.send_to_chat_after_create'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'partnership.send_to_chat_after_create_hint'.tr(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md12),
                  ],
                  OutlinedButton.icon(
                    onPressed: () => _downloadDraft(context),
                    icon: Icon(LucideIcons.download, size: 18.sp),
                    label: Text('partnership.pdf_download_draft'.tr()),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                  if (widget.negotiationId != null) ...[
                    SizedBox(height: AppSpacing.sm10),
                    OutlinedButton.icon(
                      onPressed: () => _sendDraftToChat(context),
                      icon: Icon(LucideIcons.messageSquare, size: 18.sp),
                      label: Text('partnership.chat_send_draft_cta'.tr()),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48.h),
                        foregroundColor: AppColors.success,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.sm10),
                  BlocBuilder<PartnershipCubit, PartnershipState>(
                    builder: (context, submitState) {
                      return CustomButton(
                        text: 'partnership.submit_contract'.tr(),
                        isLoading: submitState.isSubmitting,
                        onPressed: submitState.isSubmitting
                            ? null
                            : () => _submit(context),
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'partnership.sign_note'.tr(),
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String supplierName;

  const _InfoBanner({required this.supplierName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.handshake, size: 22.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Text(
              'partnership.create_banner'.tr(namedArgs: {'name': supplierName}),
              style: TextStyle(fontSize: 13.sp, color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isRequired;

  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: label,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                      children: [
                        if (isRequired)
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.error,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Icon(LucideIcons.calendar, size: 18.sp, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
