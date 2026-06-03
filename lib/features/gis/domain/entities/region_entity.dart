import 'package:freezed_annotation/freezed_annotation.dart';

part 'region_entity.freezed.dart';

@freezed
abstract class RegionEntity with _$RegionEntity {
  const factory RegionEntity({required String id, required String name}) =
      _RegionEntity;
}
