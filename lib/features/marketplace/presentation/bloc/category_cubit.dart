import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/marketplace_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final MarketplaceRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial());

  /// Ignores stale HTTP responses when product mode / biomassa type changes quickly.
  int _requestGeneration = 0;

  void _emitSafe(CategoryState next) {
    if (!isClosed) emit(next);
  }

  Future<void> getCategories({
    String? productMode,
    String? biomassaType,
    String? search,
  }) async {
    final generation = ++_requestGeneration;
    _emitSafe(CategoryLoading());
    final result = await _repository.getCategories(
      productMode: productMode,
      biomassaType: biomassaType,
      search: search,
    );
    if (isClosed || generation != _requestGeneration) return;
    result.fold(
      (failure) => _emitSafe(CategoryError(failure.message)),
      (categories) => _emitSafe(CategoryLoaded(categories)),
    );
  }
}
