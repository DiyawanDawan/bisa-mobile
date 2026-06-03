part of 'store_banner_cubit.dart';

@freezed
class StoreBannerState with _$StoreBannerState {
  const factory StoreBannerState.initial() = _Initial;
  const factory StoreBannerState.loading() = _Loading;
  const factory StoreBannerState.loaded(List<StoreBannerModel> banners) = _Loaded;
  const factory StoreBannerState.error(String message) = _Error;
}
