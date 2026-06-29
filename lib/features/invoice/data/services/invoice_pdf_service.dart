import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_assets.dart';
import '../../domain/entities/invoice_pdf_data.dart';
import '../../domain/entities/invoice_pdf_labels.dart';

class InvoicePdfGenerator {
  static const PdfColor _primary = PdfColor.fromInt(0xFF135122);
  static const PdfColor _textMuted = PdfColor.fromInt(0xFF64748B);

  /// Selaras dengan splash / branding aplikasi.
  static const String _brandName = 'BISA';

  /// Font bawaan PDF tidak mendukung em dash / emoji — normalisasi teks.
  static String _pdfSafeText(String? text) {
    if (text == null) return '';
    var s = text;
    s = s.replaceAll('\u2014', '-').replaceAll('\u2013', '-');
    s = s.replaceAll(RegExp(r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}]', unicode: true), '');
    return s.trim();
  }

  static String _qrPayload(InvoicePdfData data) {
    return data.qrData ??
        '${data.invoiceNumber}:VERIFY:${data.issuedAt.millisecondsSinceEpoch}';
  }

  static const double _pageMarginH = 22;
  static const double _pageMarginV = 18;
  static const double _gapS = 4;
  static const double _gapM = 6;
  static const double _boxPad = 6;

  static String _truncate(String? text, {int maxLen = 140}) {
    final s = _pdfSafeText(text);
    if (s.length <= maxLen) return s;
    return '${s.substring(0, maxLen)}...';
  }

  static Future<List<int>> generate(
    InvoicePdfData data, {
    required InvoicePdfLabels labels,
    String intlLocale = 'id_ID',
  }) async {
    final doc = pw.Document();
    final logoBytes = await _loadLogoBytes();
    final dateFmt = DateFormat('d MMMM yyyy, HH:mm', intlLocale);
    final currencyFmt = NumberFormat.currency(
      locale: intlLocale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final pageWidth = PdfPageFormat.a4.width - (_pageMarginH * 2);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(
          horizontal: _pageMarginH,
          vertical: _pageMarginV,
        ),
        build: (context) => pw.FittedBox(
          fit: pw.BoxFit.scaleDown,
          alignment: pw.Alignment.topCenter,
          child: pw.SizedBox(
            width: pageWidth,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                _header(data, dateFmt, logoBytes, labels),
                pw.SizedBox(height: _gapM),
                _partiesSection(data, labels),
                pw.SizedBox(height: _gapM),
                _productSection(data, currencyFmt, labels),
                pw.SizedBox(height: _gapM),
                _breakdownSection(data, currencyFmt, labels),
                pw.SizedBox(height: _gapM),
                _shippingSection(data, labels),
                if (data.specifications != null &&
                    data.specifications!.trim().isNotEmpty) ...[
                  pw.SizedBox(height: _gapM),
                  _notesSection(data.specifications!, labels),
                ],
                pw.SizedBox(height: _gapM),
                _qrSection(data, labels),
                pw.SizedBox(height: _gapS),
                _footer(labels),
              ],
            ),
          ),
        ),
      ),
    );

    return doc.save();
  }

  static Future<Uint8List?> _loadLogoBytes() async {
    try {
      final data = await rootBundle.load(AppAssets.logo);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  static pw.Widget _header(
    InvoicePdfData data,
    DateFormat dateFmt,
    Uint8List? logoBytes,
    InvoicePdfLabels labels,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(_boxPad + 2),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFDCFCE7),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoBytes != null)
                pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: 40,
                  height: 40,
                  fit: pw.BoxFit.contain,
                ),
              pw.SizedBox(width: logoBytes != null ? 8 : 0),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _brandName,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: _primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    labels.brandTagline,
                    style: const pw.TextStyle(fontSize: 7, color: _textMuted),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    labels.documentTitle,
                    style: const pw.TextStyle(fontSize: 8, color: _textMuted),
                  ),
                ],
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                _truncate(data.invoiceNumber, maxLen: 36),
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                dateFmt.format(data.issuedAt),
                style: const pw.TextStyle(fontSize: 7, color: _textMuted),
              ),
              if (data.statusLabel != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  data.statusLabel!,
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: _primary,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _partiesSection(InvoicePdfData data, InvoicePdfLabels labels) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _partyBox(
            labels.supplierLabel,
            data.supplierName,
            email: data.supplierEmail,
          ),
        ),
        pw.SizedBox(width: _gapM),
        pw.Expanded(
          child: _partyBox(
            labels.buyerLabel,
            data.buyerName,
            email: data.buyerEmail,
            company: data.buyerCompany,
          ),
        ),
      ],
    );
  }

  /// Kotak identitas pihak (Supplier/Pembeli) — menampilkan nama, email,
  /// dan opsional company. Email dicantumkan eksplisit agar tagihan PDF
  /// memuat jejak kontak resmi kedua belah pihak.
  static pw.Widget _partyBox(
    String label,
    String name, {
    String? email,
    String? company,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(_boxPad),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 7, color: _textMuted)),
          pw.SizedBox(height: 2),
          pw.Text(
            _truncate(name, maxLen: 48),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          ),
          if (company != null && company.isNotEmpty) ...[
            pw.Text(
              _truncate(company, maxLen: 40),
              style: const pw.TextStyle(fontSize: 7, color: _textMuted),
            ),
          ],
          if (email != null && email.isNotEmpty)
            pw.Text(
              _truncate(email, maxLen: 42),
              style: const pw.TextStyle(fontSize: 7),
            ),
        ],
      ),
    );
  }

  static pw.Widget _productSection(
    InvoicePdfData data,
    NumberFormat currencyFmt,
    InvoicePdfLabels labels,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          labels.productDetail,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        ),
        pw.SizedBox(height: _gapS),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell(labels.colProduct, bold: true),
                _cell(labels.colQty, bold: true),
                _cell(labels.colPrice(data.productUnit), bold: true),
                _cell(labels.colSubtotal, bold: true),
              ],
            ),
            pw.TableRow(
              children: [
                _cell(_pdfSafeText(data.productName)),
                _cell('${data.quantity.toStringAsFixed(0)} ${data.productUnit}'),
                _cell(currencyFmt.format(data.pricePerUnit)),
                _cell(currencyFmt.format(data.subtotal)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _breakdownSection(
    InvoicePdfData data,
    NumberFormat currencyFmt,
    InvoicePdfLabels labels,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(_boxPad),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          _breakdownRow(labels.subtotalGoods, currencyFmt.format(data.subtotal)),
          _breakdownRow(labels.platformFee, currencyFmt.format(data.platformFee)),
          if (data.logisticsFee > 0)
            _breakdownRow(labels.shippingFee, currencyFmt.format(data.logisticsFee)),
          _breakdownRow(labels.vat, currencyFmt.format(data.vatAmount)),
          pw.Divider(color: PdfColors.grey400),
          _breakdownRow(
            labels.total,
            currencyFmt.format(data.totalAmount),
            bold: true,
            valueColor: _primary,
          ),
        ],
      ),
    );
  }

  static pw.Widget _breakdownRow(
    String label,
    String value, {
    bool bold = false,
    PdfColor? valueColor,
  }) {
    final style = pw.TextStyle(
      fontSize: bold ? 9 : 8,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: valueColor,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  static pw.Widget _shippingSection(InvoicePdfData data, InvoicePdfLabels labels) {
    final destSnap = data.shippingSnapshot;
    final originSnap = data.sellerShippingSnapshot ??
        InvoicePdfData.originFromSnapshot(destSnap);
    final methodLines = _shippingMethodLines(data, labels);
    final hasDestination = destSnap != null && destSnap.isNotEmpty;
    final hasOrigin = originSnap != null && originSnap.isNotEmpty;

    if (!hasDestination && !hasOrigin && methodLines.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          labels.shippingTitle,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        ),
        pw.SizedBox(height: _gapS),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (hasOrigin)
              pw.Expanded(
                child: _shippingAddressBox(
                  labels.originTitle,
                  originSnap,
                  labels: labels,
                  footer: data.sellerOriginLabel != null &&
                          data.sellerOriginLabel!.isNotEmpty
                      ? labels.originFeeLocation(data.sellerOriginLabel!)
                      : null,
                ),
              ),
            if (hasOrigin && hasDestination) pw.SizedBox(width: _gapS),
            if (hasDestination)
              pw.Expanded(
                child: _shippingAddressBox(
                  labels.destinationTitle,
                  destSnap,
                  labels: labels,
                ),
              ),
          ],
        ),
        if (methodLines.isNotEmpty) ...[
          pw.SizedBox(height: _gapS),
          pw.Text(
            _truncate(methodLines.join(' · '), maxLen: 200),
            style: const pw.TextStyle(fontSize: 7, color: _textMuted),
          ),
        ],
      ],
    );
  }

  static pw.Widget _shippingAddressBox(
    String title,
    Map<String, dynamic> snap, {
    required InvoicePdfLabels labels,
    String? footer,
  }) {
    final lines = <String>[
      if (snap['recipient'] != null && snap['recipient'].toString().isNotEmpty)
        snap['recipient'].toString(),
      if (snap['phone'] != null && snap['phone'].toString().isNotEmpty)
        labels.phoneLine(snap['phone'].toString()),
      if (snap['address'] != null && snap['address'].toString().isNotEmpty)
        snap['address'].toString(),
      if (snap['regency'] != null ||
          snap['province'] != null)
        [snap['regency'], snap['province']]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(', '),
    ];

    final body = lines.map(_pdfSafeText).join(' · ');
    final full = footer != null && footer.isNotEmpty
        ? '$body · ${_pdfSafeText(footer)}'
        : body;

    return pw.Container(
      padding: const pw.EdgeInsets.all(_boxPad),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: _primary,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            _truncate(full, maxLen: 160),
            style: const pw.TextStyle(fontSize: 7),
          ),
        ],
      ),
    );
  }

  static List<String> _shippingMethodLines(
    InvoicePdfData data,
    InvoicePdfLabels labels,
  ) {
    final lines = <String>[];
    final snap = data.shippingSnapshot;
    Map<String, dynamic>? logistics;
    if (snap?['logistics'] is Map) {
      logistics = Map<String, dynamic>.from(snap!['logistics'] as Map);
    }

    final os = data.orderShipping;
    final courier = (logistics?['courierCode'] ?? os?.courierCode)?.toString();
    final courierName =
        (logistics?['courierName'] ?? os?.courierName)?.toString();
    final service = (logistics?['verifiedService'] ??
            logistics?['serviceName'] ??
            os?.serviceName)
        ?.toString();
    final destination = (logistics?['destinationLabel'] ??
            os?.destinationLabel)
        ?.toString();
    final origin = (data.sellerOriginLabel ?? os?.originLabel)?.toString();
    final etd = (logistics?['etd'] ?? os?.etd)?.toString();

    if (courier != null && courier.isNotEmpty) {
      final detail = courierName != null && courierName.isNotEmpty
          ? '$courierName ($courier)'
          : courier.toUpperCase();
      lines.add(labels.courierLine(detail));
    }
    if (service != null && service.isNotEmpty) {
      lines.add(labels.serviceLine(service));
    }
    if (origin != null && origin.isNotEmpty) {
      lines.add(labels.shippingOriginLine(origin));
    }
    if (destination != null && destination.isNotEmpty) {
      lines.add(labels.shippingDestinationLine(destination));
    }
    if (etd != null && etd.isNotEmpty) {
      lines.add(labels.etaLine(etd));
    }

    return lines;
  }

  static pw.Widget _notesSection(String notes, InvoicePdfLabels labels) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          labels.notes,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          _truncate(notes, maxLen: 180),
          style: const pw.TextStyle(fontSize: 7, color: _textMuted),
        ),
      ],
    );
  }

  static pw.Widget _qrSection(InvoicePdfData data, InvoicePdfLabels labels) {
    final payload = _qrPayload(data);
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(_boxPad),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
        color: PdfColor.fromInt(0xFFF8FAFC),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: payload,
            width: 56,
            height: 56,
          ),
          pw.SizedBox(width: _gapM),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  labels.digitalContract,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                    color: _primary,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  _truncate(data.invoiceNumber, maxLen: 36),
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  labels.qrHint,
                  style: const pw.TextStyle(fontSize: 6, color: _textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _footer(InvoicePdfLabels labels) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(color: PdfColors.grey400, height: 0.5),
        pw.SizedBox(height: _gapS),
        pw.Text(
          labels.footerDisclaimer,
          style: const pw.TextStyle(fontSize: 6, color: _textMuted),
        ),
        pw.Text(
          labels.copyright,
          style: const pw.TextStyle(fontSize: 6, color: _textMuted),
        ),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        _pdfSafeText(text),
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

class InvoicePdfExporter {
  static Future<File> generateTempFile(
    InvoicePdfData data, {
    required InvoicePdfLabels labels,
    String intlLocale = 'id_ID',
  }) async {
    final bytes = await InvoicePdfGenerator.generate(
      data,
      labels: labels,
      intlLocale: intlLocale,
    );
    final dir = await getTemporaryDirectory();
    final safeName = data.invoiceNumber.replaceAll(RegExp(r'[#/\\:*?"<>|]'), '-');
    final file = File('${dir.path}/tagihan-$safeName.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> share(
    InvoicePdfData data, {
    required InvoicePdfLabels labels,
    String intlLocale = 'id_ID',
  }) async {
    final file = await generateTempFile(
      data,
      labels: labels,
      intlLocale: intlLocale,
    );
    final safeName = data.invoiceNumber.replaceAll(RegExp(r'[#/\\:*?"<>|]'), '-');

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf', name: 'tagihan-$safeName.pdf')],
        subject: labels.shareSubject(data.invoiceNumber),
        text: labels.shareText(data.invoiceNumber),
      ),
    );
  }
}
