import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/region_entity.dart';

part 'region_model.freezed.dart';
part 'region_model.g.dart';

@freezed
abstract class RegionModel with _$RegionModel {
  const RegionModel._();

  const factory RegionModel({
    required String id,
    required String name,
  }) = _RegionModel;

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  RegionEntity toEntity() => RegionEntity(
        id: id,
        name: name,
      );
}
