import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_stats_entity.dart';
import '../../domain/entities/product_image_draft.dart';
import '../../domain/repositories/marketplace_repository.dart';

part 'product_management_state.dart';
part 'product_management_cubit.freezed.dart';

class ProductManagementCubit extends Cubit<ProductManagementState> {
  final MarketplaceRepository _repository;

  ProductManagementCubit(this._repository) : super(const ProductManagementState.initial());

  Future<void> getProductDetail(String id) async {
    emit(const ProductManagementState.loading());
    final result = await _repository.getProductById(id);
    await result.fold(
      (failure) async => emit(ProductManagementState.error(failure.message)),
      (product) async {
        final statsResult = await _repository.getProductStats(id);
        final stats = statsResult.fold((_) => null, (s) => s);
        emit(ProductManagementState.loaded(product, stats: stats));
      },
    );
  }

  Future<String?> updateField(String id, Map<String, dynamic> data) async {
    final previous = state;
    ProductEntity? product;
    ProductStatsEntity? stats;
    previous.maybeWhen(
      loaded: (p, s) {
        product = p;
        stats = s;
      },
      orElse: () {},
    );

    emit(const ProductManagementState.loading());
    final result = await _repository.updateProduct(id, data, []);
    return await result.fold<Future<String?>>(
      (failure) async {
        if (product != null) {
          emit(ProductManagementState.loaded(product!, stats: stats));
        } else {
          emit(ProductManagementState.error(failure.message));
        }
        return failure.message;
      },
      (updated) async {
        final statsResult = await _repository.getProductStats(id);
        final newStats = statsResult.fold((_) => stats, (s) => s);
        emit(ProductManagementState.loaded(updated, stats: newStats));
        return null;
      },
    );
  }

  Future<void> toggleStatus(String id, String currentStatus) async {
    final newStatus = currentStatus.toUpperCase() == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
    emit(const ProductManagementState.loading());
    final result = await _repository.updateProduct(
      id,
      {'status': newStatus},
      [],
    );
    await result.fold(
      (failure) async => emit(ProductManagementState.error(failure.message)),
      (product) async {
        final statsResult = await _repository.getProductStats(id);
        final stats = statsResult.fold((_) => null, (s) => s);
        emit(ProductManagementState.loaded(product, stats: stats));
      },
    );
  }

  Future<String?> deleteProduct(String id) async {
    final previous = state;
    ProductEntity? product;
    ProductStatsEntity? stats;
    previous.maybeWhen(
      loaded: (p, s) {
        product = p;
        stats = s;
      },
      orElse: () {},
    );

    emit(const ProductManagementState.loading());
    final result = await _repository.deleteProduct(id);
    return result.fold(
      (failure) {
        if (product != null) {
          emit(ProductManagementState.loaded(product!, stats: stats));
        } else {
          emit(ProductManagementState.error(failure.message));
        }
        return failure.message;
      },
      (_) {
        emit(const ProductManagementState.deleted());
        return null;
      },
    );
  }

  Future<void> duplicateProduct(String id) async {
    emit(const ProductManagementState.loading());
    final result = await _repository.duplicateProduct(id);
    result.fold(
      (failure) => emit(ProductManagementState.error(failure.message)),
      (product) => emit(ProductManagementState.duplicated(product)),
    );
  }

  Future<String?> updateImages(String id, List<ProductImageDraft> drafts) async {
    if (drafts.isEmpty) {
      return 'marketplace.min_one_photo_required';
    }

    final previous = state;
    ProductEntity? product;
    ProductStatsEntity? stats;
    previous.maybeWhen(
      loaded: (p, s) {
        product = p;
        stats = s;
      },
      orElse: () {},
    );

    final payload = ProductImageDraft.buildPayload(drafts);
    emit(const ProductManagementState.loading());
    final result = await _repository.updateProduct(
      id,
      {
        'syncImages': 'true',
        'imageOrder': payload.imageOrderJson,
      },
      payload.newImagePaths,
    );
    return await result.fold<Future<String?>>(
      (failure) async {
        if (product != null) {
          emit(ProductManagementState.loaded(product!, stats: stats));
        } else {
          emit(ProductManagementState.error(failure.message));
        }
        return failure.message;
      },
      (updated) async {
        final freshResult = await _repository.getProductById(id);
        final productToShow = freshResult.fold((_) => updated, (p) => p);
        final statsResult = await _repository.getProductStats(id);
        final newStats = statsResult.fold((_) => stats, (s) => s);
        emit(ProductManagementState.loaded(productToShow, stats: newStats));
        return null;
      },
    );
  }

  Future<String?> promoteProduct(String id, {int days = 7}) async {
    final previous = state;
    ProductEntity? product;
    ProductStatsEntity? stats;
    previous.maybeWhen(
      loaded: (p, s) {
        product = p;
        stats = s;
      },
      orElse: () {},
    );

    emit(const ProductManagementState.loading());
    final result = await _repository.promoteProduct(id, days: days);
    return await result.fold<Future<String?>>(
      (failure) async {
        if (product != null) {
          emit(ProductManagementState.loaded(product!, stats: stats));
        } else {
          emit(ProductManagementState.error(failure.message));
        }
        return failure.message;
      },
      (_) async {
        final freshResult = await _repository.getProductById(id);
        final productToShow = freshResult.fold((_) => product!, (p) => p);
        final statsResult = await _repository.getProductStats(id);
        final newStats = statsResult.fold((_) => stats, (s) => s);
        emit(ProductManagementState.loaded(productToShow, stats: newStats));
        return null;
      },
    );
  }

  Future<String?> uploadProductVideo(String id, String filePath) async {
    final previous = state;
    ProductEntity? product;
    ProductStatsEntity? stats;
    previous.maybeWhen(
      loaded: (p, s) {
        product = p;
        stats = s;
      },
      orElse: () {},
    );

    emit(const ProductManagementState.loading());
    final result = await _repository.uploadProductVideo(id, filePath);
    return await result.fold<Future<String?>>(
      (failure) async {
        if (product != null) {
          emit(ProductManagementState.loaded(product!, stats: stats));
        } else {
          emit(ProductManagementState.error(failure.message));
        }
        return failure.message;
      },
      (updated) async {
        final statsResult = await _repository.getProductStats(id);
        final newStats = statsResult.fold((_) => stats, (s) => s);
        emit(ProductManagementState.loaded(updated, stats: newStats));
        return null;
      },
    );
  }

  Future<String?> deleteProductVideo(String id) async {
    final previous = state;
    ProductEntity? product;
    ProductStatsEntity? stats;
    previous.maybeWhen(
      loaded: (p, s) {
        product = p;
        stats = s;
      },
      orElse: () {},
    );

    emit(const ProductManagementState.loading());
    final result = await _repository.deleteProductVideo(id);
    return await result.fold<Future<String?>>(
      (failure) async {
        if (product != null) {
          emit(ProductManagementState.loaded(product!, stats: stats));
        } else {
          emit(ProductManagementState.error(failure.message));
        }
        return failure.message;
      },
      (updated) async {
        final statsResult = await _repository.getProductStats(id);
        final newStats = statsResult.fold((_) => stats, (s) => s);
        emit(ProductManagementState.loaded(updated, stats: newStats));
        return null;
      },
    );
  }
}
