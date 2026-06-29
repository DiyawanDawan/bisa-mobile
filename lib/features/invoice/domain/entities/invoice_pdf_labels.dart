import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Localized strings for [InvoicePdfGenerator] — built from UI context.
class InvoicePdfLabels {
  const InvoicePdfLabels({
    required this.brandTagline,
    required this.documentTitle,
    required this.supplierLabel,
    required this.buyerLabel,
    required this.productDetail,
    required this.colProduct,
    required this.colQty,
    required this.colSubtotal,
    required this.subtotalGoods,
    required this.platformFee,
    required this.shippingFee,
    required this.vat,
    required this.total,
    required this.shippingTitle,
    required this.originTitle,
    required this.destinationTitle,
    required this.notes,
    required this.digitalContract,
    required this.qrHint,
    required this.footerDisclaimer,
    required this.copyright,
    required this.shareSubjectPrefix,
    required this.shareTextPrefix,
    required this.chatAttachmentPrefix,
    required this.defaultSupplierName,
    required this.courierPrefix,
    required this.servicePrefix,
    required this.shippingOriginPrefix,
    required this.shippingDestinationPrefix,
    required this.etaPrefix,
    required this.phonePrefix,
    required this.originFeeLocationPrefix,
    required this.colPriceTemplate,
  });

  factory InvoicePdfLabels.fromContext(BuildContext context) {
    return InvoicePdfLabels(
      brandTagline: 'invoice.pdf_brand_tagline'.tr(),
      documentTitle: 'invoice.pdf_document_title'.tr(),
      supplierLabel: 'invoice.pdf_supplier_label'.tr(),
      buyerLabel: 'invoice.pdf_buyer_label'.tr(),
      productDetail: 'invoice.pdf_product_detail'.tr(),
      colProduct: 'invoice.pdf_col_product'.tr(),
      colQty: 'invoice.pdf_col_qty'.tr(),
      colSubtotal: 'invoice.pdf_col_subtotal'.tr(),
      subtotalGoods: 'invoice.pdf_subtotal_goods'.tr(),
      platformFee: 'invoice.pdf_platform_fee'.tr(),
      shippingFee: 'invoice.pdf_shipping_fee'.tr(),
      vat: 'invoice.pdf_vat'.tr(),
      total: 'invoice.pdf_total'.tr(),
      shippingTitle: 'invoice.pdf_shipping_title'.tr(),
      originTitle: 'invoice.pdf_origin_title'.tr(),
      destinationTitle: 'invoice.pdf_destination_title'.tr(),
      notes: 'invoice.pdf_notes'.tr(),
      digitalContract: 'invoice.pdf_digital_contract'.tr(),
      qrHint: 'invoice.pdf_qr_hint'.tr(),
      footerDisclaimer: 'invoice.pdf_footer_disclaimer'.tr(),
      copyright: 'invoice.pdf_copyright'.tr(),
      shareSubjectPrefix: 'invoice.pdf_share_subject'.tr(),
      shareTextPrefix: 'invoice.pdf_share_text'.tr(),
      chatAttachmentPrefix: 'invoice.pdf_chat_attachment'.tr(),
      defaultSupplierName: 'invoice.pdf_default_supplier'.tr(),
      courierPrefix: 'invoice.pdf_courier_prefix'.tr(),
      servicePrefix: 'invoice.pdf_service_prefix'.tr(),
      shippingOriginPrefix: 'invoice.pdf_shipping_origin_prefix'.tr(),
      shippingDestinationPrefix: 'invoice.pdf_shipping_destination_prefix'.tr(),
      etaPrefix: 'invoice.pdf_eta_prefix'.tr(),
      phonePrefix: 'invoice.pdf_phone_prefix'.tr(),
      originFeeLocationPrefix: 'invoice.pdf_origin_fee_location_prefix'.tr(),
      colPriceTemplate: 'invoice.pdf_col_price'.tr(),
    );
  }

  final String brandTagline;
  final String documentTitle;
  final String supplierLabel;
  final String buyerLabel;
  final String productDetail;
  final String colProduct;
  final String colQty;
  final String colSubtotal;
  final String subtotalGoods;
  final String platformFee;
  final String shippingFee;
  final String vat;
  final String total;
  final String shippingTitle;
  final String originTitle;
  final String destinationTitle;
  final String notes;
  final String digitalContract;
  final String qrHint;
  final String footerDisclaimer;
  final String copyright;
  final String shareSubjectPrefix;
  final String shareTextPrefix;
  final String chatAttachmentPrefix;
  final String defaultSupplierName;
  final String courierPrefix;
  final String servicePrefix;
  final String shippingOriginPrefix;
  final String shippingDestinationPrefix;
  final String etaPrefix;
  final String phonePrefix;
  final String originFeeLocationPrefix;
  final String colPriceTemplate;

  String colPrice(String unit) =>
      colPriceTemplate.replaceAll('{unit}', unit);

  String originFeeLocation(String location) =>
      originFeeLocationPrefix.replaceAll('{location}', location);

  String phoneLine(String phone) => phonePrefix.replaceAll('{phone}', phone);

  String courierLine(String detail) =>
      courierPrefix.replaceAll('{detail}', detail);

  String serviceLine(String name) => servicePrefix.replaceAll('{name}', name);

  String shippingOriginLine(String origin) =>
      shippingOriginPrefix.replaceAll('{origin}', origin);

  String shippingDestinationLine(String destination) =>
      shippingDestinationPrefix.replaceAll('{destination}', destination);

  String etaLine(String etd) => etaPrefix.replaceAll('{etd}', etd);

  String shareSubject(String invoiceNumber) =>
      shareSubjectPrefix.replaceAll('{number}', invoiceNumber);

  String shareText(String invoiceNumber) =>
      shareTextPrefix.replaceAll('{number}', invoiceNumber);

  String chatAttachment(String invoiceNumber) =>
      chatAttachmentPrefix.replaceAll('{number}', invoiceNumber);

  static String intlLocaleFor(Locale locale) =>
      locale.languageCode == 'id' ? 'id_ID' : 'en_US';
}
