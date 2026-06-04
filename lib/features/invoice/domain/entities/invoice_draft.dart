import 'invoice_preview_entity.dart';
import '../../../orders/domain/entities/order_entity.dart';

/// Draft tagihan yang bisa diedit supplier sebelum diterbitkan.
class InvoiceDraft {
  InvoiceDraft({
    required this.recipient,
    required this.phone,
    required this.address,
    required this.regency,
    required this.province,
    required this.specifications,
    required this.quantity,
    required this.pricePerUnit,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.customerAddressId,
    this.source,
  });

  String recipient;
  String phone;
  String address;
  String regency;
  String province;
  String specifications;
  double quantity;
  double pricePerUnit;
  String? zipCode;
  double? latitude;
  double? longitude;
  String? customerAddressId;
  String? source;

  factory InvoiceDraft.fromPreview(InvoicePreviewEntity preview) {
    return InvoiceDraft.fromShippingSnapshot(
      preview.shippingSnapshot ?? {},
      specifications: preview.specifications ?? '',
      quantity: preview.quantity,
      pricePerUnit: preview.pricePerUnit,
      fallbackRecipient: preview.buyerName,
    );
  }

  factory InvoiceDraft.fromShippingSnapshot(
    Map<String, dynamic> snapshot, {
    required String specifications,
    required double quantity,
    required double pricePerUnit,
    String? fallbackRecipient,
  }) {
    return InvoiceDraft(
      recipient: snapshot['recipient']?.toString() ??
          fallbackRecipient ??
          '',
      phone: snapshot['phone']?.toString() ?? '',
      address: snapshot['address']?.toString() ?? '',
      regency: snapshot['regency']?.toString() ?? '',
      province: snapshot['province']?.toString() ?? '',
      zipCode: snapshot['zipCode']?.toString(),
      latitude: _parseCoord(snapshot['latitude']),
      longitude: _parseCoord(snapshot['longitude']),
      customerAddressId: snapshot['customerAddressId']?.toString(),
      source: snapshot['source']?.toString(),
      specifications: specifications,
      quantity: quantity,
      pricePerUnit: pricePerUnit,
    );
  }

  static double? _parseCoord(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  factory InvoiceDraft.fromOrder(OrderEntity order) {
    final snapshot = order.shippingAddressSnapshot ?? {};
    final product = order.items.isNotEmpty ? order.items.first : null;
    return InvoiceDraft(
      recipient: snapshot['recipient']?.toString() ?? order.buyer.name,
      phone: snapshot['phone']?.toString() ?? '',
      address: snapshot['address']?.toString() ?? '',
      regency: snapshot['regency']?.toString() ?? '',
      province: snapshot['province']?.toString() ?? '',
      specifications: order.specifications ?? '',
      quantity: product?.quantity ?? order.totalQuantity,
      pricePerUnit: product?.pricePerUnit ?? 0,
    );
  }

  Map<String, dynamic> toShippingSnapshot() => {
        'recipient': recipient.trim(),
        if (phone.trim().isNotEmpty) 'phone': phone.trim(),
        'address': address.trim(),
        if (regency.trim().isNotEmpty) 'regency': regency.trim(),
        if (province.trim().isNotEmpty) 'province': province.trim(),
        if (zipCode != null && zipCode!.trim().isNotEmpty) 'zipCode': zipCode!.trim(),
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (customerAddressId != null && customerAddressId!.isNotEmpty)
          'customerAddressId': customerAddressId,
        'source': source ?? 'custom',
      };

  InvoicePreviewEntity applyToPreview(InvoicePreviewEntity preview) {
    final newSubtotal = quantity * pricePerUnit;
    final baseSubtotal = preview.subtotal;
    double newPlatformFee = preview.platformFee;
    double newVat = preview.vatAmount;

    if (baseSubtotal > 0 && newSubtotal != baseSubtotal) {
      final feeRate = preview.platformFee / baseSubtotal;
      final vatRate = preview.vatAmount / baseSubtotal;
      newPlatformFee = newSubtotal * feeRate;
      newVat = newSubtotal * vatRate;
    }

    return preview.copyWith(
      quantity: quantity,
      pricePerUnit: pricePerUnit,
      subtotal: newSubtotal,
      platformFee: newPlatformFee,
      vatAmount: newVat,
      totalAmount: newSubtotal + newPlatformFee + newVat + preview.logisticsFee,
      shippingSnapshot: toShippingSnapshot(),
      specifications: specifications.trim().isEmpty ? null : specifications.trim(),
    );
  }

  List<String> validationBlockers() {
    final blockers = <String>[];
    if (recipient.trim().length < 2) {
      blockers.add('Nama penerima wajib diisi');
    }
    if (phone.trim().length < 8) {
      blockers.add('Nomor telepon penerima wajib diisi (min. 8 digit)');
    }
    if (address.trim().length < 10) {
      blockers.add('Alamat lengkap minimal 10 karakter');
    }
    if (regency.trim().isEmpty && province.trim().isEmpty) {
      blockers.add('Kabupaten/kota atau provinsi wajib diisi');
    }
    if (quantity <= 0) blockers.add('Jumlah harus lebih dari 0');
    if (pricePerUnit <= 0) blockers.add('Harga per unit harus lebih dari 0');
    return blockers;
  }

  String? validate() {
    final blockers = validationBlockers();
    return blockers.isEmpty ? null : blockers.first;
  }

  /// Validasi alamat saja (halaman edit tagihan — qty/harga dari order).
  List<String> shippingFieldBlockers() {
    return validationBlockers()
        .where(
          (b) =>
              !b.contains('Jumlah') && !b.contains('Harga per unit'),
        )
        .toList();
  }

  InvoiceDraft copyWith({
    String? recipient,
    String? phone,
    String? address,
    String? regency,
    String? province,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
    String? zipCode,
    double? latitude,
    double? longitude,
    String? customerAddressId,
    String? source,
  }) {
    return InvoiceDraft(
      recipient: recipient ?? this.recipient,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      regency: regency ?? this.regency,
      province: province ?? this.province,
      specifications: specifications ?? this.specifications,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      zipCode: zipCode ?? this.zipCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      customerAddressId: customerAddressId ?? this.customerAddressId,
      source: source ?? this.source,
    );
  }
}
