// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'negotiation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NegotiationModel _$NegotiationModelFromJson(Map<String, dynamic> json) =>
    _NegotiationModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String?,
      order: negotiationOrderFromJson(json['order']),
      productId: json['productId'] as String,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      quantity: json['quantity'],
      pricePerUnit: json['pricePerUnit'],
      totalEstimate: json['totalEstimate'],
      specifications: json['specifications'] as String?,
      roomType: json['roomType'] as String? ?? 'NEGOTIATION',
      status: json['status'] as String,
      isLocked: json['isLocked'] as bool,
      rejectionReason: json['rejectionReason'] as String?,
      closedBy: json['closedBy'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      product: NegotiationProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      buyer: NegotiationParticipantModel.fromJson(
        json['buyer'] as Map<String, dynamic>,
      ),
      seller: NegotiationParticipantModel.fromJson(
        json['seller'] as Map<String, dynamic>,
      ),
      messages: (json['messages'] as List<dynamic>?)
          ?.map(
            (e) => NegotiationMessageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      messagesTotal: (json['messagesTotal'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NegotiationModelToJson(_NegotiationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'order': negotiationOrderToJson(instance.order),
      'productId': instance.productId,
      'buyerId': instance.buyerId,
      'sellerId': instance.sellerId,
      'quantity': instance.quantity,
      'pricePerUnit': instance.pricePerUnit,
      'totalEstimate': instance.totalEstimate,
      'specifications': instance.specifications,
      'roomType': instance.roomType,
      'status': instance.status,
      'isLocked': instance.isLocked,
      'rejectionReason': instance.rejectionReason,
      'closedBy': instance.closedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'product': instance.product,
      'buyer': instance.buyer,
      'seller': instance.seller,
      'messages': instance.messages,
      'messagesTotal': instance.messagesTotal,
    };

_NegotiationProductModel _$NegotiationProductModelFromJson(
  Map<String, dynamic> json,
) => _NegotiationProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  pricePerUnit: json['pricePerUnit'],
  unit: json['unit'] as String,
  minOrder: json['minOrder'] ?? 1,
  description: json['description'] as String?,
  biomassaType: json['biomassaType'] as String?,
  regency: json['regency'] as String?,
  province: json['province'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$NegotiationProductModelToJson(
  _NegotiationProductModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'thumbnailUrl': instance.thumbnailUrl,
  'pricePerUnit': instance.pricePerUnit,
  'unit': instance.unit,
  'minOrder': instance.minOrder,
  'description': instance.description,
  'biomassaType': instance.biomassaType,
  'regency': instance.regency,
  'province': instance.province,
  'status': instance.status,
};

_NegotiationParticipantModel _$NegotiationParticipantModelFromJson(
  Map<String, dynamic> json,
) => _NegotiationParticipantModel(
  id: json['id'] as String,
  name: json['fullName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  profile: json['profile'] == null
      ? null
      : NegotiationParticipantProfileModel.fromJson(
          json['profile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NegotiationParticipantModelToJson(
  _NegotiationParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.name,
  'avatarUrl': instance.avatarUrl,
  'profile': instance.profile,
};

_NegotiationParticipantProfileModel
_$NegotiationParticipantProfileModelFromJson(Map<String, dynamic> json) =>
    _NegotiationParticipantProfileModel(
      companyName: json['companyName'] as String?,
    );

Map<String, dynamic> _$NegotiationParticipantProfileModelToJson(
  _NegotiationParticipantProfileModel instance,
) => <String, dynamic>{'companyName': instance.companyName};

_NegotiationMessageModel _$NegotiationMessageModelFromJson(
  Map<String, dynamic> json,
) => _NegotiationMessageModel(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  content: json['content'] as String,
  attachmentUrl: json['attachmentUrl'] as String?,
  isSystemMessage: json['isSystemMessage'] as bool? ?? false,
  isRead: json['isRead'] as bool? ?? false,
  isDeleted: json['isDeleted'] as bool? ?? false,
  editedAt: json['editedAt'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$NegotiationMessageModelToJson(
  _NegotiationMessageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'senderId': instance.senderId,
  'content': instance.content,
  'attachmentUrl': instance.attachmentUrl,
  'isSystemMessage': instance.isSystemMessage,
  'isRead': instance.isRead,
  'isDeleted': instance.isDeleted,
  'editedAt': instance.editedAt,
  'createdAt': instance.createdAt,
};
