import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_assets.dart';
import '../../domain/entities/partnership_entity.dart';

class PartnershipPdfData {
  final String contractNumber;
  final String title;
  final String status;
  final bool isDraft;
  final String buyerName;
  final String? buyerCompany;
  final String supplierName;
  final String? supplierCompany;
  final String? description;
  final String? productCategory;
  final double? estimatedMonthlyQty;
  final String? priceAgreement;
  final String? deliveryTerms;
  final String? paymentTerms;
  final String? specialTerms;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? buyerSignedAt;
  final DateTime? sellerSignedAt;
  final DateTime? platformSignedAt;
  final String? buyerSignerName;
  final String? sellerSignerName;
  final String? platformSignerName;
  final int signedCount;
  final int requiredSigners;
  final DateTime generatedAt;

  const PartnershipPdfData({
    required this.contractNumber,
    required this.title,
    required this.status,
    required this.isDraft,
    required this.buyerName,
    this.buyerCompany,
    required this.supplierName,
    this.supplierCompany,
    this.description,
    this.productCategory,
    this.estimatedMonthlyQty,
    this.priceAgreement,
    this.deliveryTerms,
    this.paymentTerms,
    this.specialTerms,
    required this.startDate,
    required this.endDate,
    this.buyerSignedAt,
    this.sellerSignedAt,
    this.platformSignedAt,
    this.buyerSignerName,
    this.sellerSignerName,
    this.platformSignerName,
    this.signedCount = 0,
    this.requiredSigners = 3,
    required this.generatedAt,
  });

  factory PartnershipPdfData.fromEntity(PartnershipEntity p) {
    final draftStatuses = {'PENDING', 'AWAITING_SIGNATURE'};
    return PartnershipPdfData(
      contractNumber: p.contractNumber,
      title: p.title,
      status: p.status,
      isDraft: draftStatuses.contains(p.status) || !p.isFullySigned,
      buyerName: p.buyer.fullName,
      buyerCompany: p.buyerCompanyName ?? p.buyer.companyName,
      supplierName: p.supplier.fullName,
      supplierCompany: p.sellerCompanyName ?? p.supplier.companyName,
      description: p.description,
      productCategory: p.productCategory,
      estimatedMonthlyQty: p.estimatedMonthlyQty,
      priceAgreement: p.priceAgreement,
      deliveryTerms: p.deliveryTerms,
      paymentTerms: p.paymentTerms,
      specialTerms: p.specialTerms,
      startDate: p.startDate,
      endDate: p.endDate,
      buyerSignedAt: p.buyerSignedAt,
      sellerSignedAt: p.sellerSignedAt,
      platformSignedAt: p.platformSignedAt,
      buyerSignerName: p.buyerSignerName ?? p.buyer.fullName,
      sellerSignerName: p.sellerSignerName ?? p.supplier.fullName,
      platformSignerName: p.platformSignerName ?? 'BISA Agri',
      signedCount: p.signedCount,
      requiredSigners: p.requiredSigners,
      generatedAt: DateTime.now(),
    );
  }

  factory PartnershipPdfData.fromDraftForm({
    required String title,
    required String buyerName,
    String? buyerCompany,
    required String supplierName,
    String? supplierCompany,
    String? description,
    String? productCategory,
    double? estimatedMonthlyQty,
    String? priceAgreement,
    String? deliveryTerms,
    String? paymentTerms,
    String? specialTerms,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final stamp = DateFormat('yyyyMMdd-HHmm').format(DateTime.now());
    return PartnershipPdfData(
      contractNumber: 'DRAFT-$stamp',
      title: title.trim().isEmpty ? 'Draf Kontrak Kerjasama' : title.trim(),
      status: 'DRAFT',
      isDraft: true,
      buyerName: buyerName,
      buyerCompany: buyerCompany,
      supplierName: supplierName,
      supplierCompany: supplierCompany,
      description: description,
      productCategory: productCategory,
      estimatedMonthlyQty: estimatedMonthlyQty,
      priceAgreement: priceAgreement,
      deliveryTerms: deliveryTerms,
      paymentTerms: paymentTerms,
      specialTerms: specialTerms,
      startDate: startDate,
      endDate: endDate,
      signedCount: 0,
      requiredSigners: 3,
      generatedAt: DateTime.now(),
    );
  }
}

class PartnershipPdfLabels {
  final String docTitle;
  final String draftWatermark;
  final String contractNumber;
  final String status;
  final String parties;
  final String buyer;
  final String supplier;
  final String company;
  final String terms;
  final String description;
  final String category;
  final String qty;
  final String price;
  final String delivery;
  final String payment;
  final String special;
  final String period;
  final String signatures;
  final String buyerSign;
  final String supplierSign;
  final String platformSign;
  final String signed;
  final String notSigned;
  final String progress;
  final String generatedAt;
  final String footer;
  final String draftNote;
  final String shareSubject;
  final String shareText;

  const PartnershipPdfLabels({
    required this.docTitle,
    required this.draftWatermark,
    required this.contractNumber,
    required this.status,
    required this.parties,
    required this.buyer,
    required this.supplier,
    required this.company,
    required this.terms,
    required this.description,
    required this.category,
    required this.qty,
    required this.price,
    required this.delivery,
    required this.payment,
    required this.special,
    required this.period,
    required this.signatures,
    required this.buyerSign,
    required this.supplierSign,
    required this.platformSign,
    required this.signed,
    required this.notSigned,
    required this.progress,
    required this.generatedAt,
    required this.footer,
    required this.draftNote,
    required this.shareSubject,
    required this.shareText,
  });
}

class PartnershipPdfGenerator {
  static const PdfColor _primary = PdfColor.fromInt(0xFF135122);
  static const PdfColor _muted = PdfColor.fromInt(0xFF64748B);
  static const PdfColor _draft = PdfColor.fromInt(0xFFB45309);

  static String _safe(String? text) {
    if (text == null) return '-';
    var s = text
        .replaceAll('\u2014', '-')
        .replaceAll('\u2013', '-')
        .replaceAll(RegExp(r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}]', unicode: true), '')
        .trim();
    return s.isEmpty ? '-' : s;
  }

  static Future<List<int>> generate(
    PartnershipPdfData data, {
    required PartnershipPdfLabels labels,
    String intlLocale = 'id_ID',
  }) async {
    final doc = pw.Document();
    final logoBytes = await _loadLogo();
    final dateFmt = DateFormat('d MMMM yyyy', intlLocale);
    final dateTimeFmt = DateFormat('d MMMM yyyy, HH:mm', intlLocale);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 32),
        build: (context) => [
          _header(data, labels, logoBytes, dateFmt),
          if (data.isDraft) ...[
            pw.SizedBox(height: 10),
            _draftBanner(labels),
          ],
          pw.SizedBox(height: 14),
          _parties(data, labels),
          pw.SizedBox(height: 14),
          _terms(data, labels, dateFmt),
          pw.SizedBox(height: 14),
          _signatures(data, labels, dateFmt),
          pw.SizedBox(height: 16),
          pw.Text(
            '${labels.generatedAt}: ${dateTimeFmt.format(data.generatedAt)}',
            style: const pw.TextStyle(fontSize: 8, color: _muted),
          ),
          if (data.isDraft) ...[
            pw.SizedBox(height: 6),
            pw.Text(
              labels.draftNote,
              style: const pw.TextStyle(fontSize: 8, color: _draft),
            ),
          ],
          pw.SizedBox(height: 10),
          pw.Text(
            labels.footer,
            style: const pw.TextStyle(fontSize: 7, color: _muted),
          ),
        ],
      ),
    );

    return doc.save();
  }

  static Future<Uint8List?> _loadLogo() async {
    try {
      final data = await rootBundle.load(AppAssets.logo);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  static pw.Widget _header(
    PartnershipPdfData data,
    PartnershipPdfLabels labels,
    Uint8List? logoBytes,
    DateFormat dateFmt,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFDCFCE7),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (logoBytes != null) ...[
            pw.Image(pw.MemoryImage(logoBytes), width: 42, height: 42),
            pw.SizedBox(width: 10),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'BISA',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: _primary,
                  ),
                ),
                pw.Text(
                  labels.docTitle,
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  _safe(data.title),
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                '${labels.contractNumber}:',
                style: const pw.TextStyle(fontSize: 8, color: _muted),
              ),
              pw.Text(
                _safe(data.contractNumber),
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${labels.status}: ${_safe(data.status)}',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: data.isDraft ? _draft : _primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _draftBanner(PartnershipPdfLabels labels) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFFEF3C7),
        border: pw.Border.all(color: _draft, width: 1),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Center(
        child: pw.Text(
          labels.draftWatermark,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: _draft,
          ),
        ),
      ),
    );
  }

  static pw.Widget _parties(PartnershipPdfData data, PartnershipPdfLabels labels) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle(labels.parties),
        pw.SizedBox(height: 6),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: _partyBox(
                labels.buyer,
                data.buyerName,
                data.buyerCompany,
                labels.company,
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _partyBox(
                labels.supplier,
                data.supplierName,
                data.supplierCompany,
                labels.company,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _partyBox(
    String role,
    String name,
    String? company,
    String companyLabel,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromInt(0xFFE2E8F0)),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(role, style: const pw.TextStyle(fontSize: 8, color: _muted)),
          pw.SizedBox(height: 2),
          pw.Text(
            _safe(name),
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          if (company != null && company.trim().isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              '$companyLabel: ${_safe(company)}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _terms(
    PartnershipPdfData data,
    PartnershipPdfLabels labels,
    DateFormat dateFmt,
  ) {
    final rows = <MapEntry<String, String>>[
      if (data.description?.trim().isNotEmpty == true)
        MapEntry(labels.description, data.description!),
      if (data.productCategory?.trim().isNotEmpty == true)
        MapEntry(labels.category, data.productCategory!),
      if (data.estimatedMonthlyQty != null)
        MapEntry(labels.qty, '${data.estimatedMonthlyQty} ton/bulan'),
      if (data.priceAgreement?.trim().isNotEmpty == true)
        MapEntry(labels.price, data.priceAgreement!),
      if (data.deliveryTerms?.trim().isNotEmpty == true)
        MapEntry(labels.delivery, data.deliveryTerms!),
      if (data.paymentTerms?.trim().isNotEmpty == true)
        MapEntry(labels.payment, data.paymentTerms!),
      if (data.specialTerms?.trim().isNotEmpty == true)
        MapEntry(labels.special, data.specialTerms!),
      MapEntry(
        labels.period,
        '${dateFmt.format(data.startDate)} - ${dateFmt.format(data.endDate)}',
      ),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle(labels.terms),
        pw.SizedBox(height: 6),
        ...rows.map(
          (e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  e.key,
                  style: const pw.TextStyle(fontSize: 8, color: _muted),
                ),
                pw.Text(_safe(e.value), style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _signatures(
    PartnershipPdfData data,
    PartnershipPdfLabels labels,
    DateFormat dateFmt,
  ) {
    String signText(DateTime? at, String? name) {
      if (at == null) return labels.notSigned;
      return '${labels.signed}: ${dateFmt.format(at)}${name != null ? ' ($name)' : ''}';
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle(labels.signatures),
        pw.SizedBox(height: 4),
        pw.Text(
          labels.progress
              .replaceAll('{signed}', '${data.signedCount}')
              .replaceAll('{total}', '${data.requiredSigners}'),
          style: const pw.TextStyle(fontSize: 8, color: _muted),
        ),
        pw.SizedBox(height: 8),
        _signRow(labels.buyerSign, signText(data.buyerSignedAt, data.buyerSignerName)),
        pw.SizedBox(height: 6),
        _signRow(
          labels.supplierSign,
          signText(data.sellerSignedAt, data.sellerSignerName),
        ),
        pw.SizedBox(height: 6),
        _signRow(
          labels.platformSign,
          signText(data.platformSignedAt, data.platformSignerName),
        ),
      ],
    );
  }

  static pw.Widget _signRow(String label, String value) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromInt(0xFFE2E8F0)),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 2),
          pw.Text(value, style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  static pw.Widget _sectionTitle(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
        color: _primary,
      ),
    );
  }
}

class PartnershipPdfExporter {
  static Future<File> generateTempFile(
    PartnershipPdfData data, {
    required PartnershipPdfLabels labels,
    String intlLocale = 'id_ID',
  }) async {
    final bytes = await PartnershipPdfGenerator.generate(
      data,
      labels: labels,
      intlLocale: intlLocale,
    );
    final dir = await getTemporaryDirectory();
    final safeName = data.contractNumber.replaceAll(RegExp(r'[#/\\:*?"<>|]'), '-');
    final prefix = data.isDraft ? 'draf-kontrak' : 'kontrak';
    final file = File('${dir.path}/$prefix-$safeName.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> share(
    PartnershipPdfData data, {
    required PartnershipPdfLabels labels,
    String intlLocale = 'id_ID',
  }) async {
    final file = await generateTempFile(
      data,
      labels: labels,
      intlLocale: intlLocale,
    );
    final safeName = data.contractNumber.replaceAll(RegExp(r'[#/\\:*?"<>|]'), '-');
    final prefix = data.isDraft ? 'draf-kontrak' : 'kontrak';

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            file.path,
            mimeType: 'application/pdf',
            name: '$prefix-$safeName.pdf',
          ),
        ],
        subject: labels.shareSubject.replaceAll('{number}', data.contractNumber),
        text: labels.shareText.replaceAll('{number}', data.contractNumber),
      ),
    );
  }
}
