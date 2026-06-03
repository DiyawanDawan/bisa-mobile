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

class InvoicePdfGenerator {
  static const PdfColor _primary = PdfColor.fromInt(0xFF135122);
  static const PdfColor _textMuted = PdfColor.fromInt(0xFF64748B);

  static Future<List<int>> generate(InvoicePdfData data) async {
    final doc = pw.Document();
    final logoBytes = await _loadLogoBytes();
    final dateFmt = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');
    final currencyFmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _header(data, dateFmt, logoBytes),
          pw.SizedBox(height: 20),
          _partiesSection(data),
          pw.SizedBox(height: 20),
          _productSection(data, currencyFmt),
          pw.SizedBox(height: 16),
          _breakdownSection(data, currencyFmt),
          pw.SizedBox(height: 16),
          _shippingSection(data),
          if (data.specifications != null && data.specifications!.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            _notesSection(data.specifications!),
          ],
          if (data.qrData != null) ...[
            pw.SizedBox(height: 20),
            _qrSection(data),
          ],
          pw.SizedBox(height: 24),
          _footer(),
        ],
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
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFDCFCE7),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoBytes != null)
                pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: 72,
                  height: 32,
                  fit: pw.BoxFit.contain,
                )
              else
                pw.Text(
                  'BISA',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: _primary,
                  ),
                ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Tagihan B2B Biomassa',
                style: const pw.TextStyle(fontSize: 11, color: _textMuted),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                data.invoiceNumber,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                dateFmt.format(data.issuedAt),
                style: const pw.TextStyle(fontSize: 9, color: _textMuted),
              ),
              if (data.statusLabel != null) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  data.statusLabel!,
                  style: pw.TextStyle(
                    fontSize: 9,
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

  static pw.Widget _partiesSection(InvoicePdfData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _partyBox(
            'Supplier (Penjual)',
            data.supplierName,
            email: data.supplierEmail,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _partyBox(
            'Pembeli',
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
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: _textMuted)),
          pw.SizedBox(height: 4),
          pw.Text(name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          if (company != null && company.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(company, style: const pw.TextStyle(fontSize: 9, color: _textMuted)),
          ],
          if (email != null && email.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Row(
              children: [
                pw.Text(
                  'Email: ',
                  style: const pw.TextStyle(fontSize: 9, color: _textMuted),
                ),
                pw.Expanded(
                  child: pw.Text(
                    email,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _productSection(InvoicePdfData data, NumberFormat currencyFmt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Detail Produk', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
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
                _cell('Produk', bold: true),
                _cell('Qty', bold: true),
                _cell('Harga/Unit', bold: true),
                _cell('Subtotal', bold: true),
              ],
            ),
            pw.TableRow(
              children: [
                _cell(data.productName),
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

  static pw.Widget _breakdownSection(InvoicePdfData data, NumberFormat currencyFmt) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          _breakdownRow('Subtotal Barang', currencyFmt.format(data.subtotal)),
          _breakdownRow('Biaya Platform', currencyFmt.format(data.platformFee)),
          if (data.logisticsFee > 0)
            _breakdownRow('Biaya Ongkir', currencyFmt.format(data.logisticsFee)),
          _breakdownRow('PPN', currencyFmt.format(data.vatAmount)),
          pw.Divider(color: PdfColors.grey400),
          _breakdownRow(
            'Total Tagihan',
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
      fontSize: bold ? 12 : 10,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: valueColor,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10)),
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  static pw.Widget _shippingSection(InvoicePdfData data) {
    final snap = data.shippingSnapshot;
    if (snap == null || snap.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final lines = <String>[
      if (snap['recipient'] != null) 'Penerima: ${snap['recipient']}',
      if (snap['phone'] != null) 'Telepon: ${snap['phone']}',
      if (snap['address'] != null) 'Alamat: ${snap['address']}',
      if (snap['regency'] != null || snap['province'] != null)
        'Wilayah: ${[snap['regency'], snap['province']].whereType<String>().join(', ')}',
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Alamat Pengiriman', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        ...lines.map(
          (line) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(line, style: const pw.TextStyle(fontSize: 10)),
          ),
        ),
      ],
    );
  }

  static pw.Widget _notesSection(String notes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Catatan / Spesifikasi', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Text(notes, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _qrSection(InvoicePdfData data) {
    return pw.Row(
      children: [
        pw.BarcodeWidget(
          barcode: pw.Barcode.qrCode(),
          data: data.qrData!,
          width: 72,
          height: 72,
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Kontrak Digital', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(
                'Scan QR untuk verifikasi tagihan resmi BISA.',
                style: const pw.TextStyle(fontSize: 9, color: _textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _footer() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 8),
        pw.Text(
          'Syarat & Ketentuan Singkat',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Tagihan ini diterbitkan melalui platform BISA. Pembayaran dilakukan via escrow '
          'hingga pesanan selesai. Pastikan detail produk, jumlah, dan alamat pengiriman '
          'sudah sesuai sebelum melakukan pembayaran.',
          style: const pw.TextStyle(fontSize: 8, color: _textMuted),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '© BISA — Biomassa Indonesia Sustainable Alliance',
          style: const pw.TextStyle(fontSize: 8, color: _textMuted),
        ),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

class InvoicePdfExporter {
  static Future<File> generateTempFile(InvoicePdfData data) async {
    final bytes = await InvoicePdfGenerator.generate(data);
    final dir = await getTemporaryDirectory();
    final safeName = data.invoiceNumber.replaceAll(RegExp(r'[#/\\:*?"<>|]'), '-');
    final file = File('${dir.path}/tagihan-$safeName.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> share(InvoicePdfData data) async {
    final file = await generateTempFile(data);
    final safeName = data.invoiceNumber.replaceAll(RegExp(r'[#/\\:*?"<>|]'), '-');

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf', name: 'tagihan-$safeName.pdf')],
        subject: 'Tagihan BISA ${data.invoiceNumber}',
        text: 'Tagihan BISA — ${data.invoiceNumber}',
      ),
    );
  }
}
