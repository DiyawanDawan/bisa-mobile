import 'package:easy_localization/easy_localization.dart';

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
      messages: messages,
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

const _storeReadinessLabelKeys = <String, String>{
  'companyName': 'readiness.field_company_name',
  'phone': 'readiness.field_phone',
  'storeLocation': 'readiness.field_store_location',
  'businessAddress': 'readiness.field_business_address',
  'rajaongkirOriginId': 'readiness.field_rajaongkir_origin',
  'kycVerified': 'readiness.field_kyc_verified',
};

const _buyerReadinessLabelKeys = <String, String>{
  'shippingAddress': 'readiness.field_shipping_address',
  'recipientPhone': 'readiness.field_recipient_phone',
  'shippingRegion': 'readiness.field_shipping_region',
};

String readinessLabelForKey(String key) {
  final labelKey =
      _storeReadinessLabelKeys[key] ?? _buyerReadinessLabelKeys[key];
  return labelKey != null ? labelKey.tr() : key;
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
