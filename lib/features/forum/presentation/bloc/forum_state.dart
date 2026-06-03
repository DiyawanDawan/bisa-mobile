part of 'forum_cubit.dart';

@freezed
class ForumState with _$ForumState {
  const factory ForumState.initial() = _Initial;
  const factory ForumState.loading() = _Loading;
  const factory ForumState.loaded(List<ForumPostEntity> posts) = _Loaded;
  const factory ForumState.categoriesLoaded(
    List<ForumCategoryEntity> categories,
  ) = _CategoriesLoaded;
  const factory ForumState.success() = _Success;
  const factory ForumState.error(String message) = _Error;
}
