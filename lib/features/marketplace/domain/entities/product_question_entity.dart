class ProductQuestionEntity {
  const ProductQuestionEntity({
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

  bool get isAnswered => answer != null && answer!.trim().isNotEmpty;
}
