import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../invoice/domain/entities/invoice_deal_economics.dart';
import '../../domain/entities/negotiation_entity.dart';

part 'negotiation_model.freezed.dart';
part 'negotiation_model.g.dart';

class NegotiationOrderSummaryModel {
  const NegotiationOrderSummaryModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    this.totalAmount,
  });

  final String id;
  final String orderNumber;
  final String status;
  final dynamic totalAmount;

  factory NegotiationOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return NegotiationOrderSummaryModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      totalAmount: json['totalAmount'],
    );
  }

  NegotiationOrderSummaryEntity toEntity() => NegotiationOrderSummaryEntity(
        id: id,
        orderNumber: orderNumber,
        status: status,
        totalAmount: totalAmount != null
            ? double.tryParse(totalAmount.toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderNumber': orderNumber,
        'status': status,
        'totalAmount': totalAmount,
      };
}

NegotiationOrderSummaryModel? negotiationOrderFromJson(Object? json) {
  if (json == null) return null;
  return NegotiationOrderSummaryModel.fromJson(json as Map<String, dynamic>);
}

Object? negotiationOrderToJson(NegotiationOrderSummaryModel? order) =>
    order?.toJson();

@freezed
abstract class NegotiationModel with _$NegotiationModel {
  const factory NegotiationModel({
    required String id,
    String? orderId,
    @JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson)
    NegotiationOrderSummaryModel? order,
    required String productId,
    required String buyerId,
    required String sellerId,
    required dynamic quantity,
    required dynamic pricePerUnit,
    required dynamic totalEstimate,
    String? specifications,
    @Default('NEGOTIATION') String roomType,
    required String status,
    required bool isLocked,
    String? rejectionReason,
    String? closedBy,
    required String createdAt,
    required String updatedAt,
    required NegotiationProductModel product,
    required NegotiationParticipantModel buyer,
    required NegotiationParticipantModel seller,
    List<NegotiationMessageModel>? messages,
    int? messagesTotal,
    Map<String, dynamic>? economics,
  }) = _NegotiationModel;

  factory NegotiationModel.fromJson(Map<String, dynamic> json) => _$NegotiationModelFromJson(json);

  const NegotiationModel._();

  NegotiationEntity toEntity() => NegotiationEntity(
        id: id,
        orderId: orderId,
        order: order?.toEntity(),
        productId: productId,
        buyerId: buyerId,
        sellerId: sellerId,
        quantity: double.tryParse(quantity.toString()) ?? 0.0,
        pricePerUnit: double.tryParse(pricePerUnit.toString()) ?? 0.0,
        totalEstimate: double.tryParse(totalEstimate.toString()) ?? 0.0,
        specifications: specifications,
        roomType: roomType,
        status: status,
        isLocked: isLocked,
        rejectionReason: rejectionReason,
        closedBy: closedBy,
        createdAt: DateTime.parse(createdAt),
        updatedAt: DateTime.parse(updatedAt),
        product: product.toEntity(),
        buyer: buyer.toEntity(),
        seller: seller.toEntity(),
        messages: messages?.map((e) => e.toEntity()).toList(),
        messagesTotal: messagesTotal,
        economics: economics != null
            ? InvoiceDealEconomics.fromJson(economics!)
            : null,
      );
}

@freezed
abstract class NegotiationProductModel with _$NegotiationProductModel {
  const factory NegotiationProductModel({
    required String id,
    required String name,
    String? thumbnailUrl,
    required dynamic pricePerUnit,
    required String unit,
    @Default(1) dynamic minOrder,
    @Default(0) dynamic stock,
    String? description,
    String? biomassaType,
    String? regency,
    String? province,
    String? status,
  }) = _NegotiationProductModel;

  factory NegotiationProductModel.fromJson(Map<String, dynamic> json) =>
      _$NegotiationProductModelFromJson(json);

  const NegotiationProductModel._();

  NegotiationProductEntity toEntity() => NegotiationProductEntity(
        id: id,
        name: name,
        thumbnailUrl: resolveMediaField(thumbnailUrl),
        pricePerUnit: double.tryParse(pricePerUnit.toString()) ?? 0.0,
        unit: unit,
        minOrder: double.tryParse(minOrder.toString()) ?? 1.0,
        stock: double.tryParse(stock.toString()) ?? 0.0,
        description: description,
        biomassaType: biomassaType,
        regency: regency,
        province: province,
        status: status,
      );
}

@freezed
abstract class NegotiationParticipantModel with _$NegotiationParticipantModel {
  const factory NegotiationParticipantModel({
    required String id,
    @JsonKey(name: 'fullName') required String name,
    String? avatarUrl,
    @JsonKey(name: 'profile') NegotiationParticipantProfileModel? profile,
  }) = _NegotiationParticipantModel;

  factory NegotiationParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$NegotiationParticipantModelFromJson(json);

  const NegotiationParticipantModel._();

  NegotiationParticipantEntity toEntity() => NegotiationParticipantEntity(
        id: id,
        name: name,
        avatarUrl: resolveMediaField(avatarUrl),
        companyName: profile?.companyName,
      );
}

@freezed
abstract class NegotiationParticipantProfileModel with _$NegotiationParticipantProfileModel {
  const factory NegotiationParticipantProfileModel({
    String? companyName,
  }) = _NegotiationParticipantProfileModel;

  factory NegotiationParticipantProfileModel.fromJson(Map<String, dynamic> json) =>
      _$NegotiationParticipantProfileModelFromJson(json);
}

Object? _negotiationSenderRoleFromJson(Map json, String key) {
  final direct = json['senderRole'];
  if (direct != null) return direct;
  return (json['sender'] as Map?)?['role'];
}

@freezed
abstract class NegotiationMessageModel with _$NegotiationMessageModel {
  const factory NegotiationMessageModel({
    required String id,
    required String senderId,
    required String content,
    String? attachmentUrl,
    @Default(false) bool isSystemMessage,
    @Default(false) bool isRead,
    @Default(false) bool isDeleted,
    String? editedAt,
    @JsonKey(readValue: _negotiationSenderRoleFromJson) String? senderRole,
    required String createdAt,
  }) = _NegotiationMessageModel;

  factory NegotiationMessageModel.fromJson(Map<String, dynamic> json) =>
      _$NegotiationMessageModelFromJson(json);

  const NegotiationMessageModel._();

  NegotiationMessageEntity toEntity() => NegotiationMessageEntity(
        id: id,
        senderId: senderId,
        content: content,
        attachmentUrl: resolveMediaField(attachmentUrl),
        isSystemMessage: isSystemMessage,
        isRead: isRead,
        isDeleted: isDeleted,
        editedAt: editedAt != null ? DateTime.tryParse(editedAt!) : null,
        senderRole: senderRole,
        createdAt: DateTime.parse(createdAt),
      );
}
