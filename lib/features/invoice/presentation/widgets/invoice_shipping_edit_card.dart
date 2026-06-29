import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import '../../domain/entities/invoice_draft.dart';

class InvoiceShippingEditCard extends StatefulWidget {
  const InvoiceShippingEditCard({
    super.key,
    required this.draft,
    this.onChanged,
    this.readOnly = false,
    this.hintText,
  });

  final InvoiceDraft draft;
  final ValueChanged<InvoiceDraft>? onChanged;
  final bool readOnly;
  final String? hintText;

  @override
  State<InvoiceShippingEditCard> createState() => _InvoiceShippingEditCardState();
}

class _InvoiceShippingEditCardState extends State<InvoiceShippingEditCard> {
  late final TextEditingController _recipientCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _regencyCtrl;
  late final TextEditingController _provinceCtrl;

  @override
  void initState() {
    super.initState();
    _recipientCtrl = TextEditingController(text: widget.draft.recipient);
    _phoneCtrl = TextEditingController(text: widget.draft.phone);
    _addressCtrl = TextEditingController(text: widget.draft.address);
    _regencyCtrl = TextEditingController(text: widget.draft.regency);
    _provinceCtrl = TextEditingController(text: widget.draft.province);
  }

  @override
  void didUpdateWidget(covariant InvoiceShippingEditCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft == widget.draft) return;
    _recipientCtrl.text = widget.draft.recipient;
    _phoneCtrl.text = widget.draft.phone;
    _addressCtrl.text = widget.draft.address;
    _regencyCtrl.text = widget.draft.regency;
    _provinceCtrl.text = widget.draft.province;
  }

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _regencyCtrl.dispose();
    _provinceCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    if (widget.readOnly || widget.onChanged == null) return;
    widget.onChanged!(
      widget.draft.copyWith(
        recipient: _recipientCtrl.text,
        phone: _phoneCtrl.text,
        address: _addressCtrl.text,
        regency: _regencyCtrl.text,
        province: _provinceCtrl.text,
        source: widget.draft.source == 'buyer_profile' ||
                widget.draft.source == 'buyer_saved_address'
            ? 'custom'
            : widget.draft.source,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_location_alt_outlined,
                  size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'invoice.shipping_section'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            widget.hintText ??
                (widget.readOnly
                    ? 'invoice.edit_hint_readonly'.tr()
                    : 'invoice.edit_hint_editable'.tr()),
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            label: 'invoice.edit_recipient_label'.tr(),
            hint: 'invoice.edit_recipient_hint'.tr(),
            controller: _recipientCtrl,
            enabled: !widget.readOnly,
            onChanged: widget.readOnly ? null : (_) => _emit(),
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            label: 'invoice.shipping_address_phone'.tr(),
            hint: 'profile.edit_phone_hint'.tr(),
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            enabled: !widget.readOnly,
            onChanged: widget.readOnly ? null : (_) => _emit(),
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            label: 'invoice.shipping_address_street'.tr(),
            hint: 'invoice.edit_address_hint'.tr(),
            controller: _addressCtrl,
            maxLines: 3,
            enabled: !widget.readOnly,
            onChanged: widget.readOnly ? null : (_) => _emit(),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'invoice.edit_regency_label'.tr(),
                  hint: 'invoice.edit_regency_hint'.tr(),
                  controller: _regencyCtrl,
                  enabled: !widget.readOnly,
                  onChanged: widget.readOnly ? null : (_) => _emit(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextField(
                  label: 'invoice.edit_province_label'.tr(),
                  hint: 'invoice.edit_province_hint'.tr(),
                  controller: _provinceCtrl,
                  enabled: !widget.readOnly,
                  onChanged: widget.readOnly ? null : (_) => _emit(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
