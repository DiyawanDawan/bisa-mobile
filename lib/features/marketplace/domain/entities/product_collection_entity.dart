import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_collection_entity.freezed.dart';

@freezed
abstract class ProductCollectionEntity with _$ProductCollectionEntity {
  const factory ProductCollectionEntity({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? thumbnailUrl,
    @Default(true) bool isActive,
  }) = _ProductCollectionEntity;
}
