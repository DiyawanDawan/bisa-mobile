// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoicePreviewModel _$InvoicePreviewModelFromJson(Map<String, dynamic> json) =>
    _InvoicePreviewModel(
      negotiationId: json['negotiationId'] as String,
      product: InvoicePreviewProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      buyer: InvoicePreviewBuyerModel.fromJson(
        json['buyer'] as Map<String, dynamic>,
      ),
      quantity: json['quantity'],
      pricePerUnit: json['pricePerUnit'],
      subtotal: json['subtotal'],
      platformFee: json['platformFee'],
      logisticsFee: json['logisticsFee'],
      vatAmount: json['vatAmount'],
      totalAmount: json['totalAmount'],
      specifications: json['specifications'] as String?,
      shippingSnapshot: json['buyerShippingSnapshot'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$InvoicePreviewModelToJson(
  _InvoicePreviewModel instance,
) => <String, dynamic>{
  'negotiationId': instance.negotiationId,
  'product': instance.product,
  'buyer': instance.buyer,
  'quantity': instance.quantity,
  'pricePerUnit': instance.pricePerUnit,
  'subtotal': instance.subtotal,
  'platformFee': instance.platformFee,
  'logisticsFee': instance.logisticsFee,
  'vatAmount': instance.vatAmount,
  'totalAmount': instance.totalAmount,
  'specifications': instance.specifications,
  'buyerShippingSnapshot': instance.shippingSnapshot,
};

_InvoicePreviewProductModel _$InvoicePreviewProductModelFromJson(
  Map<String, dynamic> json,
) => _InvoicePreviewProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  unit: json['unit'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  pricePerUnit: json['pricePerUnit'] ?? 0,
  stock: json['stock'] ?? 0,
  minOrder: json['minOrder'] ?? 1,
);

Map<String, dynamic> _$InvoicePreviewProductModelToJson(
  _InvoicePreviewProductModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'unit': instance.unit,
  'thumbnailUrl': instance.thumbnailUrl,
  'pricePerUnit': instance.pricePerUnit,
  'stock': instance.stock,
  'minOrder': instance.minOrder,
};

_InvoicePreviewBuyerModel _$InvoicePreviewBuyerModelFromJson(
  Map<String, dynamic> json,
) => _InvoicePreviewBuyerModel(
  id: json['id'] as String,
  name: json['fullName'] as String,
  profile: json['profile'] == null
      ? null
      : InvoicePreviewBuyerProfileModel.fromJson(
          json['profile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$InvoicePreviewBuyerModelToJson(
  _InvoicePreviewBuyerModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.name,
  'profile': instance.profile,
};

_InvoicePreviewBuyerProfileModel _$InvoicePreviewBuyerProfileModelFromJson(
  Map<String, dynamic> json,
) => _InvoicePreviewBuyerProfileModel(
  companyName: json['companyName'] as String?,
);

Map<String, dynamic> _$InvoicePreviewBuyerProfileModelToJson(
  _InvoicePreviewBuyerProfileModel instance,
) => <String, dynamic>{'companyName': instance.companyName};
