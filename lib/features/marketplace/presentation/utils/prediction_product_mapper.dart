import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/iot_prediction_import_sheet.dart';
import '../widgets/product_specs_sheet.dart';

/// Map hasil prediksi AI/IoT → draft produk marketplace.
IotPredictionImportResult mapPredictionToProductSeed(
  Map<String, dynamic> prediction, {
  Map<String, dynamic>? inputs,
}) {
  final merged = <String, dynamic>{
    ...prediction,
    if (inputs != null) ...inputs,
  };

  final grade = merged['predictedGrade']?.toString() ?? 'B';
  final cOrganik = merged['cOrganik'];
  final yieldPct = merged['predictedYield'];
  final suhu = merged['suhuPirolisis'];
  final waktu = merged['waktuPembakaran'];
  final biomassa = merged['biomassaType']?.toString() ?? 'BIOCHAR';
  final deviceName =
      merged['iotDeviceName']?.toString() ?? merged['deviceName']?.toString();

  Map<String, dynamic>? meta;
  final raw = merged['rawOutput'];
  if (raw != null) {
    try {
      meta = jsonDecode(raw.toString()) as Map<String, dynamic>;
    } catch (_) {}
  }

  final pricePerTon = meta?['predicted_price_idr_per_ton'];

  final entries = <ProductSpecEntry>[
    if (cOrganik != null)
      ProductSpecEntry(label: 'Kemurnian Karbon', value: '$cOrganik%'),
    if (yieldPct != null)
      ProductSpecEntry(label: 'Yield Produksi', value: '$yieldPct%'),
    if (suhu != null)
      ProductSpecEntry(label: 'Suhu Pirolisis', value: '$suhu°C'),
    if (waktu != null)
      ProductSpecEntry(label: 'Waktu Pembakaran', value: '$waktu menit'),
    if (pricePerTon != null)
      ProductSpecEntry(
        label: 'Harga Estimasi ML',
        value: 'Rp $pricePerTon/ton',
      ),
    ProductSpecEntry(
      label: 'Verifikasi',
      value: deviceName ??
          (meta?['source'] == 'iot-realtime' ? 'IoT + ML' : 'ML BISA'),
    ),
  ];

  final biomassaLabel = biomassa.replaceAll('_', ' ');
  final nameHint = deviceName != null
      ? 'Biochar Grade $grade — $deviceName'
      : 'Biochar Grade $grade — $biomassaLabel';

  return IotPredictionImportResult(
    predictionId: merged['id'].toString(),
    grade: grade,
    biomassaType: biomassa,
    specsData: ProductSpecsData(entries: entries),
    suggestedName: nameHint,
    suggestedPricePerUnit: pricePerTon is num
        ? pricePerTon.toDouble()
        : num.tryParse('$pricePerTon')?.toDouble(),
  );
}

String productSeedAppliedMessage() => 'marketplace.import_iot_applied'.tr();

Future<void> openAddProductFromPrediction(
  BuildContext context, {
  required Map<String, dynamic> prediction,
  Map<String, dynamic>? inputs,
  bool closeCurrentSheet = false,
}) async {
  final id = prediction['id'];
  if (id == null) return;

  final seed = mapPredictionToProductSeed(prediction, inputs: inputs);
  if (closeCurrentSheet && Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
  if (!context.mounted) return;
  await context.push('/add-product', extra: seed);
}
