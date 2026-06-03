import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
abstract class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String productId,
    required String userId,
    required String userName,
    String? userAvatar,
    required double rating,
    required String comment,
    String? reply,
    required DateTime createdAt,
    List<String>? images,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

extension ReviewModelMediaX on ReviewModel {
  ReviewModel withResolvedMedia() {
    final resolvedImages = images
        ?.map((u) => resolveMediaField(u))
        .whereType<String>()
        .where((u) => u.isNotEmpty)
        .toList();
    return copyWith(
      userAvatar: resolveMediaField(userAvatar),
      images: resolvedImages == null || resolvedImages.isEmpty
          ? images
          : resolvedImages,
    );
  }
}
