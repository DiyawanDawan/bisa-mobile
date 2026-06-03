/// Tujuan ruang chat buyer–seller untuk satu produk.
enum NegotiationChatPurpose {
  /// Tanya stok, spesifikasi, pengiriman — tanpa tawar harga.
  inquiry,

  /// Negosiasi harga / penawaran.
  negotiation,
}

extension NegotiationChatPurposeApi on NegotiationChatPurpose {
  String get apiValue => name;
}
