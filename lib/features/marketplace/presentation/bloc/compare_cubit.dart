import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../utils/compare_list_store.dart';

class CompareState extends Equatable {
  static const maxItems = 3;

  final List<ProductEntity> products;
  final List<CompareSavedList> savedLists;

  const CompareState({
    this.products = const [],
    this.savedLists = const [],
  });

  bool contains(String productId) =>
      products.any((p) => p.id == productId);

  CompareState copyWith({
    List<ProductEntity>? products,
    List<CompareSavedList>? savedLists,
  }) =>
      CompareState(
        products: products ?? this.products,
        savedLists: savedLists ?? this.savedLists,
      );

  @override
  List<Object?> get props => [products, savedLists];
}

class CompareCubit extends Cubit<CompareState> {
  CompareCubit(this._store) : super(const CompareState()) {
    _loadSaved();
  }

  final CompareListStore _store;

  void _loadSaved() {
    final lists = _store.load();
    if (lists.isNotEmpty) {
      emit(state.copyWith(savedLists: lists));
    }
  }

  Future<void> _persistSaved() async {
    await _store.save(state.savedLists);
  }

  /// Returns null on success, or i18n error key if rejected.
  String? toggle(ProductEntity product) {
    if (state.contains(product.id)) {
      emit(CompareState(
        products: state.products.where((p) => p.id != product.id).toList(),
        savedLists: state.savedLists,
      ));
      return null;
    }
    if (state.products.length >= CompareState.maxItems) {
      return 'product.compare_max_reached';
    }
    emit(CompareState(
      products: [...state.products, product],
      savedLists: state.savedLists,
    ));
    return null;
  }

  void remove(String productId) {
    emit(CompareState(
      products: state.products.where((p) => p.id != productId).toList(),
      savedLists: state.savedLists,
    ));
  }

  void clear() => emit(CompareState(savedLists: state.savedLists));

  /// Simpan keranjang aktif sebagai daftar bernama (watch-later style).
  Future<String?> saveCurrentAsNamedList(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'product.compare_list_name_required';
    if (state.products.isEmpty) return 'product.compare_list_empty';
    if (state.savedLists.length >= CompareListStore.maxLists) {
      return 'product.compare_list_max_saved';
    }
    final duplicate = state.savedLists.any(
      (l) => l.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (duplicate) return 'product.compare_list_name_duplicate';

    final entry = CompareSavedList(
      id: 'cmp_${DateTime.now().microsecondsSinceEpoch}',
      name: trimmed,
      products: List<ProductEntity>.from(state.products),
    );
    emit(CompareState(
      products: state.products,
      savedLists: [...state.savedLists, entry],
    ));
    await _persistSaved();
    return null;
  }

  /// Muat daftar tersimpan ke keranjang aktif.
  void loadSavedList(String id) {
    final match = state.savedLists.where((l) => l.id == id);
    if (match.isEmpty) return;
    emit(CompareState(
      products: List<ProductEntity>.from(match.first.products),
      savedLists: state.savedLists,
    ));
  }

  Future<void> deleteSavedList(String id) async {
    emit(CompareState(
      products: state.products,
      savedLists: state.savedLists.where((l) => l.id != id).toList(),
    ));
    await _persistSaved();
  }
}
