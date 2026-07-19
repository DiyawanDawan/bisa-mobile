import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_collection_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../../data/models/supplier_model.dart';

part 'marketplace_state.dart';
part 'marketplace_cubit.freezed.dart';

class MarketplaceCubit extends Cubit<MarketplaceState> {
  static String activeProductMode = 'BIOMASS_MATERIAL';

  final MarketplaceRepository _repository;
  int _currentPage = 1;
  static const int _limit = 10;
  bool _hasReachedMax = false;
  String? _currentUserId;
  String? _cachedSearch;
  String? _cachedStatus;
  String? _cachedCategoryId;
  int? _cachedLimit;

  MarketplaceCubit(this._repository) : super(const MarketplaceState.initial());

  void _emitSafe(MarketplaceState next) {
    if (!isClosed) emit(next);
  }

  Future<void> getProducts({
    String? search,
    String? biomassaType,
    String? categoryId,
    String? userId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? minCarbonPurity,
    double? maxMoistureContent,
    String? sortBy,
    String? sortOrder,
    String? status,
    String? productMode,
    String? cropType,
    bool? availableNow,
    bool? preHarvestBookable,
    bool? canBook,
    int? limit,
    bool refresh = true,
  }) async {
    if (userId != null) _currentUserId = userId;
    if (refresh) {
      _cachedSearch = search;
      _cachedStatus = status;
      _cachedCategoryId = categoryId;
      if (limit != null) _cachedLimit = limit;
    }

    final querySearch = search ?? _cachedSearch;
    final queryStatus = status ?? _cachedStatus;
    final queryCategoryId = categoryId ?? _cachedCategoryId;

    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      _emitSafe(const MarketplaceState.loading());
    } else {
      if (_hasReachedMax) return;
    }

    final result = await _repository.getProducts(
      search: querySearch,
      biomassaType: biomassaType,
      categoryId: queryCategoryId,
      userId: userId ?? _currentUserId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      minCarbonPurity: minCarbonPurity,
      maxMoistureContent: maxMoistureContent,
      sortBy: sortBy,
      sortOrder: sortOrder,
      status: queryStatus,
      productMode: productMode,
      cropType: cropType,
      availableNow: availableNow,
      preHarvestBookable: preHarvestBookable,
      canBook: canBook,
      page: _currentPage,
      limit: limit ?? _limit,
    );

    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (newProducts) {
        if (isClosed) return;
        if (newProducts.isEmpty) {
          _hasReachedMax = true;
        }

        final currentProducts = state.maybeWhen(
          loaded: (products, _) => products,
          orElse: () => <ProductEntity>[],
        );

        final allProducts = refresh ? newProducts : [...currentProducts, ...newProducts];
        
        final currentLimit = limit ?? _limit;
        if (newProducts.length < currentLimit) {
          _hasReachedMax = true;
        } else {
          _currentPage++;
        }

        _emitSafe(MarketplaceState.loaded(allProducts, hasReachedMax: _hasReachedMax));
      },
    );
  }

  Future<void> getMyProducts({
    String? search,
    String? status,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    int? limit,
    bool refresh = true,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      _emitSafe(const MarketplaceState.loading());
    } else {
      if (_hasReachedMax) return;
    }

    final result = await _repository.getMyProducts(
      search: search,
      status: status,
      categoryId: categoryId,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: _currentPage,
      limit: limit ?? _limit,
    );

    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (newProducts) {
        if (isClosed) return;
        if (newProducts.isEmpty) _hasReachedMax = true;

        final currentProducts = state.maybeWhen(
          loaded: (products, _) => products,
          orElse: () => <ProductEntity>[],
        );
        final allProducts =
            refresh ? newProducts : [...currentProducts, ...newProducts];
        final currentLimit = limit ?? _limit;
        if (newProducts.length < currentLimit) {
          _hasReachedMax = true;
        } else {
          _currentPage++;
        }
        _emitSafe(
          MarketplaceState.loaded(allProducts, hasReachedMax: _hasReachedMax),
        );
      },
    );
  }

  Future<void> getProductById(String id) async {
    _emitSafe(const MarketplaceState.loading());
    final result = await _repository.getProductById(id);
    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (product) => _emitSafe(MarketplaceState.loaded([product], hasReachedMax: true)),
    );
  }

  Future<void> createProduct(
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    emit(const MarketplaceState.loading());
    final result = await _repository.createProduct(data, imagePaths);
    result.fold(
      (failure) => emit(MarketplaceState.error(failure.message)),
      (_) => _refreshProductList(),
    );
  }

  Future<void> updateProduct(
    String id,
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    emit(const MarketplaceState.loading());
    final result = await _repository.updateProduct(id, data, imagePaths);
    result.fold(
      (failure) => emit(MarketplaceState.error(failure.message)),
      (_) => _refreshProductList(),
    );
  }

  Future<void> deleteProduct(String id) async {
    emit(const MarketplaceState.loading());
    final result = await _repository.deleteProduct(id);
    result.fold(
      (failure) => emit(MarketplaceState.error(failure.message)),
      (_) => _refreshProductList(),
    );
  }

  Future<void> _refreshProductList() => getProducts(
        userId: _currentUserId,
        search: _cachedSearch,
        status: _cachedStatus,
        categoryId: _cachedCategoryId,
        limit: _cachedLimit,
        refresh: true,
      );

  Future<void> getSuppliers({
    String? search,
    bool? verified,
    String? productMode,
    String? biomassaType,
    String? province,
    String? regency,
    int page = 1,
    int limit = 20,
  }) async {
    _emitSafe(const MarketplaceState.loading());
    final result = await _repository.getSuppliers(
      search: search,
      verified: verified,
      productMode: productMode,
      biomassaType: biomassaType,
      province: province,
      regency: regency,
      page: page,
      limit: limit,
    );
    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (suppliers) => _emitSafe(MarketplaceState.suppliersLoaded(suppliers)),
    );
  }

  Future<void> getSupplierProfile(String id) async {
    _emitSafe(const MarketplaceState.loading());
    final result = await _repository.getSupplierProfile(id);
    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (supplier) => _emitSafe(MarketplaceState.suppliersLoaded(<SupplierModel>[supplier])),
    );
  }

  Future<void> getFeaturedProducts() async {
    _emitSafe(const MarketplaceState.loading());
    final result = await _repository.getFeaturedProducts();
    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (products) => _emitSafe(MarketplaceState.loaded(products, hasReachedMax: true)),
    );
  }

  Future<void> getCollections() async {
    _emitSafe(const MarketplaceState.loading());
    final result = await _repository.getCollections();
    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (collections) => _emitSafe(MarketplaceState.collectionsLoaded(collections)),
    );
  }

  Future<void> getProductsByCollection(
    String slug, {
    int? limit,
    bool refresh = true,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      _emitSafe(const MarketplaceState.loading());
    } else {
      if (_hasReachedMax) return;
    }

    final result = await _repository.getProductsByCollection(
      slug,
      page: _currentPage,
      limit: limit ?? _limit,
    );

    if (isClosed) return;
    result.fold(
      (failure) => _emitSafe(MarketplaceState.error(failure.message)),
      (newProducts) {
        if (isClosed) return;
        if (newProducts.isEmpty) {
          _hasReachedMax = true;
        }

        final currentProducts = state.maybeWhen(
          loaded: (products, _) => products,
          orElse: () => <ProductEntity>[],
        );

        final allProducts = refresh ? newProducts : [...currentProducts, ...newProducts];
        
        final currentLimit = limit ?? _limit;
        if (newProducts.length < currentLimit) {
          _hasReachedMax = true;
        } else {
          _currentPage++;
        }

        _emitSafe(MarketplaceState.loaded(allProducts, hasReachedMax: _hasReachedMax));
      },
    );
  }
}
