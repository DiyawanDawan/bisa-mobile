part of 'product_management_cubit.dart';

@freezed
class ProductManagementState with _$ProductManagementState {
  const factory ProductManagementState.initial() = _Initial;
  const factory ProductManagementState.loading() = _Loading;
  const factory ProductManagementState.loaded(
    ProductEntity product, {
    ProductStatsEntity? stats,
  }) = _Loaded;
  const factory ProductManagementState.deleted() = _Deleted;
  const factory ProductManagementState.duplicated(ProductEntity product) = _Duplicated;
  const factory ProductManagementState.error(String message) = _Error;
}
