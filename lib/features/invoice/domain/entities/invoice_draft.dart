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
  });

  String recipient;
  String phone;
  String address;
  String regency;
  String province;
  String specifications;
  double quantity;
  double pricePerUnit;

  factory InvoiceDraft.fromPreview(InvoicePreviewEntity preview) {
    final snapshot = preview.shippingSnapshot ?? {};
    return InvoiceDraft(
      recipient: snapshot['recipient']?.toString() ?? preview.buyerName,
      phone: snapshot['phone']?.toString() ?? '',
      address: snapshot['address']?.toString() ?? '',
      regency: snapshot['regency']?.toString() ?? '',
      province: snapshot['province']?.toString() ?? '',
      specifications: preview.specifications ?? '',
      quantity: preview.quantity,
      pricePerUnit: preview.pricePerUnit,
    );
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

  String? validate() {
    if (recipient.trim().isEmpty) return 'Nama penerima wajib diisi';
    if (address.trim().length < 10) {
      return 'Alamat pengiriman minimal 10 karakter';
    }
    if (quantity <= 0) return 'Jumlah harus lebih dari 0';
    if (pricePerUnit <= 0) return 'Harga per unit harus lebih dari 0';
    return null;
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
    );
  }
}
