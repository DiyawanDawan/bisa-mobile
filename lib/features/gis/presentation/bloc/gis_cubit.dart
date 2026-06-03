import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/entities/waste_point_entity.dart';
import '../../domain/repositories/gis_repository.dart';

part 'gis_state.dart';
part 'gis_cubit.freezed.dart';

class GisCubit extends Cubit<GisState> {
  final GisRepository _repository;

  GisCubit(this._repository) : super(const GisState.initial());

  Future<void> _loadRegions({
    required String level,
    String? parentId,
    String? search,
    bool force = false,
  }) async {
    final cached = await _repository.getRegions(
      level: level,
      parentId: parentId,
      search: search,
      forceRefresh: force,
    );

    return cached.fold(
      (failure) => emit(GisState.error(failure.message)),
      (regions) => emit(GisState.loaded(regions)),
    );
  }

  Future<void> getCountries({bool force = false}) async {
    final cached = _repository.peekRegions(level: 'country');
    if (!force && cached != null && cached.isNotEmpty) {
      emit(GisState.loaded(cached));
      return;
    }
    emit(const GisState.loading());
    await _loadRegions(level: 'country', force: force);
  }

  Future<void> getProvinces(String countryId, {bool force = false}) async {
    final cached = _repository.peekRegions(
      level: 'province',
      parentId: countryId,
    );
    if (!force && cached != null && cached.isNotEmpty) {
      emit(GisState.loaded(cached));
      return;
    }
    emit(const GisState.loading());
    await _loadRegions(level: 'province', parentId: countryId, force: force);
  }

  Future<void> getRegencies(String provinceId, {bool force = false}) async {
    final cached = _repository.peekRegions(
      level: 'regency',
      parentId: provinceId,
    );
    if (!force && cached != null && cached.isNotEmpty) {
      emit(GisState.loaded(cached));
      return;
    }
    emit(const GisState.loading());
    await _loadRegions(level: 'regency', parentId: provinceId, force: force);
  }

  Future<void> getDistricts(String regencyId, {bool force = false}) async {
    final cached = _repository.peekRegions(
      level: 'district',
      parentId: regencyId,
    );
    if (!force && cached != null && cached.isNotEmpty) {
      emit(GisState.loaded(cached));
      return;
    }
    emit(const GisState.loading());
    await _loadRegions(level: 'district', parentId: regencyId, force: force);
  }

  /// Desa/kelurahan: gunakan [search] (min. 2 huruf) — backend membatasi hasil.
  Future<void> getVillages(
    String districtId, {
    String? search,
    bool force = false,
  }) async {
    final query = search?.trim();
    if (query != null && query.isNotEmpty && query.length < 2) {
      emit(const GisState.loaded([]));
      return;
    }

    final cached = _repository.peekRegions(
      level: 'village',
      parentId: districtId,
      search: query,
    );
    if (!force && cached != null) {
      emit(GisState.loaded(cached));
      return;
    }
    emit(const GisState.loading());
    await _loadRegions(
      level: 'village',
      parentId: districtId,
      search: query,
      force: force,
    );
  }

  Future<void> getWastePoints() async {
    emit(const GisState.loading());
    final result = await _repository.getWastePoints();
    result.fold(
      (failure) => emit(GisState.error(failure.message)),
      (points) => emit(GisState.wasteMapLoaded(points)),
    );
  }

  Future<void> matchSupplyDemand(double lat, double lng, double radius) async {
    emit(const GisState.loading());
    final result = await _repository.matchSupplyDemand(lat, lng, radius);
    result.fold(
      (failure) => emit(GisState.error(failure.message)),
      (data) => emit(GisState.matchLoaded(data)),
    );
  }
}
