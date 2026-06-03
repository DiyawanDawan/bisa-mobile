import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/datasources/store_banner_remote_data_source.dart';
import '../../data/models/store_banner_model.dart';

part 'store_banner_state.dart';
part 'store_banner_cubit.freezed.dart';

class StoreBannerCubit extends Cubit<StoreBannerState> {
  StoreBannerCubit(this._dataSource) : super(const StoreBannerState.initial());

  final StoreBannerRemoteDataSource _dataSource;
  String? _lastUserId;

  void _emitSafe(StoreBannerState next) {
    if (!isClosed) emit(next);
  }

  Future<void> loadMyBanners() async {
    _emitSafe(const StoreBannerState.loading());
    try {
      final banners = await _dataSource.getMyBanners();
      _emitSafe(StoreBannerState.loaded(banners));
    } catch (e) {
      _emitSafe(StoreBannerState.error(e.toString()));
    }
  }

  Future<void> loadUserBanners(String userId) async {
    _lastUserId = userId;
    _emitSafe(const StoreBannerState.loading());
    try {
      final banners = await _dataSource.getUserBanners(userId);
      _emitSafe(StoreBannerState.loaded(banners));
    } catch (e) {
      _emitSafe(StoreBannerState.error(e.toString()));
    }
  }

  Future<void> retryLastUserBanners() async {
    if (_lastUserId != null) {
      await loadUserBanners(_lastUserId!);
    }
  }

  Future<void> uploadBanner(String imagePath) async {
    final previous = state;
    try {
      await _dataSource.uploadBanner(imagePath);
      await loadMyBanners();
    } catch (e) {
      _emitSafe(StoreBannerState.error(e.toString()));
      _emitSafe(previous);
    }
  }

  Future<void> deleteBanner(String bannerId) async {
    final previous = state;
    previous.maybeWhen(
      loaded: (banners) {
        _emitSafe(StoreBannerState.loaded(
          banners.where((b) => b.id != bannerId).toList(),
        ));
      },
      orElse: () {},
    );
    try {
      await _dataSource.deleteBanner(bannerId);
      await loadMyBanners();
    } catch (e) {
      _emitSafe(StoreBannerState.error(e.toString()));
      _emitSafe(previous);
    }
  }

  Future<void> toggleActive(String bannerId, bool isActive) async {
    try {
      await _dataSource.toggleBannerActive(bannerId, isActive);
      await loadMyBanners();
    } catch (e) {
      _emitSafe(StoreBannerState.error(e.toString()));
    }
  }
}
