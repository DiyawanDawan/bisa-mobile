import '../../data/models/category_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded(this.categories);

  List<CategoryModel> get roots => _treeRoots();
  List<CategoryModel> get flatList => categories;

  static const int maxDepth = 3;

  List<CategoryModel> _treeRoots() {
    return categories
        .where((c) => c.parentId == null)
        .map((c) => _attachChildren(c))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  CategoryModel _attachChildren(CategoryModel parent) {
    final children = categories
        .where((c) => c.parentId == parent.id)
        .map((c) => _attachChildren(c))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return parent.copyWith(children: children);
  }

  /// Returns the full path name for display (e.g. "Makanan > Snack > Keripik")
  String categoryPath(String categoryId) {
    final result = <String>[];
    _buildPath(categoryId, result);
    return result.reversed.join(' > ');
  }

  void _buildPath(String id, List<String> path) {
    final cat = categories.firstWhere(
      (c) => c.id == id,
      orElse: () => CategoryModel(id: '', name: ''),
    );
    if (cat.id.isEmpty) return;
    path.add(cat.name);
    if (cat.parentId != null) {
      _buildPath(cat.parentId!, path);
    }
  }

  String categoryLevelLabel(int level) {
    switch (level) {
      case 1:
        return 'Kategori utama';
      case 2:
        return 'Sub-kategori';
      case 3:
        return 'Sub-sub-kategori';
      default:
        return 'Level $level';
    }
  }
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}
