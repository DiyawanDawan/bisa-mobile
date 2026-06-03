part of 'marketplace_cubit.dart';

@freezed
class MarketplaceState with _$MarketplaceState {
  const factory MarketplaceState.initial() = _Initial;
  const factory MarketplaceState.loading() = _Loading;
  const factory MarketplaceState.loaded(List<ProductEntity> products, {@Default(false) bool hasReachedMax}) = _Loaded;
  const factory MarketplaceState.suppliersLoaded(List<SupplierModel> suppliers) = _SuppliersLoaded;
  const factory MarketplaceState.collectionsLoaded(List<ProductCollectionEntity> collections) = _CollectionsLoaded;
  const factory MarketplaceState.error(String message) = _Error;
}
