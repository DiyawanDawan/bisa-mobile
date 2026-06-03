part of 'gis_cubit.dart';

@freezed
class GisState with _$GisState {
  const factory GisState.initial() = _Initial;
  const factory GisState.loading() = _Loading;
  const factory GisState.loaded(List<RegionEntity> regions) = _Loaded;
  const factory GisState.wasteMapLoaded(List<WastePointEntity> points) = _WasteMapLoaded;
  const factory GisState.matchLoaded(Map<String, dynamic> data) = _MatchLoaded;
  const factory GisState.error(String message) = _Error;
}
