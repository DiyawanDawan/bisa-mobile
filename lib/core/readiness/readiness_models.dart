class RoleReadiness {
  const RoleReadiness({
    required this.ready,
    required this.missing,
    required this.messages,
  });

  final bool ready;
  final List<String> missing;
  final List<String> messages;

  factory RoleReadiness.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RoleReadiness(ready: true, missing: [], messages: []);
    }
    final missing = (json['missing'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final messages = (json['messages'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return RoleReadiness(
      ready: json['ready'] == true,
      missing: missing,
      messages: messages.isNotEmpty
          ? messages
          : missing.map((key) => readinessLabelForKey(key)).toList(),
    );
  }
}

class UserReadiness {
  const UserReadiness({
    required this.role,
    this.store,
    this.buyer,
  });

  final String role;
  final RoleReadiness? store;
  final RoleReadiness? buyer;

  factory UserReadiness.fromJson(Map<String, dynamic> json) {
    return UserReadiness(
      role: json['role']?.toString() ?? '',
      store: json['store'] != null
          ? RoleReadiness.fromJson(json['store'] as Map<String, dynamic>)
          : null,
      buyer: json['buyer'] != null
          ? RoleReadiness.fromJson(json['buyer'] as Map<String, dynamic>)
          : null,
    );
  }
}

const storeReadinessLabels = <String, String>{
  'companyName': 'Nama toko / perusahaan',
  'phone': 'Nomor telepon',
  'storeLocation': 'Provinsi & kabupaten/kota toko',
  'businessAddress': 'Alamat bisnis (min. 10 karakter)',
  'rajaongkirOriginId': 'Lokasi asal pengiriman RajaOngkir',
  'kycVerified': 'Verifikasi KYC disetujui',
};

const buyerReadinessLabels = <String, String>{
  'shippingAddress': 'Alamat pengiriman (min. 10 karakter)',
  'recipientPhone': 'Nomor telepon penerima',
  'shippingRegion': 'Kabupaten/kota atau provinsi tujuan',
};

String readinessLabelForKey(String key) {
  return storeReadinessLabels[key] ??
      buyerReadinessLabels[key] ??
      key;
}

String? readinessRouteForStoreKey(String key) {
  switch (key) {
    case 'companyName':
    case 'phone':
    case 'storeLocation':
    case 'businessAddress':
      return '/edit-profile';
    case 'rajaongkirOriginId':
      return '/supplier-shipping-origin';
    case 'kycVerified':
      return '/verification';
    default:
      return '/edit-profile';
  }
}

String? readinessRouteForBuyerKey(String key) {
  switch (key) {
    case 'shippingAddress':
    case 'shippingRegion':
      return '/addresses';
    case 'recipientPhone':
      return '/edit-profile';
    default:
      return '/addresses';
  }
}
