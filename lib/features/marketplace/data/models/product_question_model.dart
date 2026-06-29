import '../../../../core/utils/media_url_utils.dart';
import '../../domain/entities/product_question_entity.dart';

class ProductQuestionModel {
  const ProductQuestionModel({
    required this.id,
    required this.productId,
    required this.question,
    this.answer,
    this.answeredAt,
    required this.createdAt,
    required this.askerName,
    this.askerAvatarUrl,
    this.answeredByName,
  });

  final String id;
  final String productId;
  final String question;
  final String? answer;
  final DateTime? answeredAt;
  final DateTime createdAt;
  final String askerName;
  final String? askerAvatarUrl;
  final String? answeredByName;

  factory ProductQuestionModel.fromJson(Map<String, dynamic> json) {
    final asker = json['asker'] as Map<String, dynamic>?;
    final answeredBy = json['answeredBy'] as Map<String, dynamic>?;
    return ProductQuestionModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString(),
      answeredAt: json['answeredAt'] != null
          ? DateTime.tryParse(json['answeredAt'].toString())
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      askerName: asker?['fullName']?.toString() ?? 'Buyer',
      askerAvatarUrl: resolveMediaField(asker?['avatarUrl']?.toString()),
      answeredByName: answeredBy?['fullName']?.toString(),
    );
  }

  ProductQuestionEntity toEntity() => ProductQuestionEntity(
        id: id,
        productId: productId,
        question: question,
        answer: answer,
        answeredAt: answeredAt,
        createdAt: createdAt,
        askerName: askerName,
        askerAvatarUrl: askerAvatarUrl,
        answeredByName: answeredByName,
      );
}
