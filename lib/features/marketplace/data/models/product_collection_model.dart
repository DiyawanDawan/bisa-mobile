import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_collection_entity.dart';

part 'product_collection_model.freezed.dart';
part 'product_collection_model.g.dart';

@freezed
abstract class ProductCollectionModel with _$ProductCollectionModel {
  const factory ProductCollectionModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? thumbnailUrl,
    @Default(true) bool isActive,
  }) = _ProductCollectionModel;

  factory ProductCollectionModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCollectionModelFromJson(json);

  const ProductCollectionModel._();

  factory ProductCollectionModel.fromEntity(ProductCollectionEntity entity) =>
      ProductCollectionModel(
        id: entity.id,
        name: entity.name,
        slug: entity.slug,
        description: entity.description,
        thumbnailUrl: entity.thumbnailUrl,
        isActive: entity.isActive,
      );

  ProductCollectionEntity toEntity() => ProductCollectionEntity(
    id: id,
    name: name,
    slug: slug,
    description: description,
    thumbnailUrl: thumbnailUrl,
    isActive: isActive,
  );
}
