import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forum_entity.dart';
import '../../domain/entities/forum_media.dart';
import '../../domain/repositories/forum_repository.dart';

part 'forum_state.dart';
part 'forum_cubit.freezed.dart';

class ForumCubit extends Cubit<ForumState> {
  final ForumRepository _repository;

  ForumCubit(this._repository) : super(const ForumState.initial());

  String? _lastKeyword;
  String? _lastCategoryId;
  String? _lastTag;

  String? _lastGroupId;

  Future<void> getPosts({
    String? keyword,
    String? categoryId,
    String? tag,
    String? groupId,
    bool showLoading = true,
    bool clearTag = false,
  }) async {
    _lastKeyword = keyword ?? _lastKeyword;
    _lastCategoryId = categoryId ?? _lastCategoryId;
    _lastTag = clearTag ? null : (tag ?? _lastTag);
    _lastGroupId = groupId ?? _lastGroupId;

    if (showLoading) {
      emit(const ForumState.loading());
    }

    final result = await _repository.getPosts(
      keyword: _lastKeyword,
      categoryId: _lastCategoryId,
      tag: _lastTag,
      groupId: _lastGroupId,
    );
    result.fold((failure) {
      if (showLoading) emit(ForumState.error(failure.message));
    }, (posts) => emit(ForumState.loaded(posts)));
  }

  String? get currentTagFilter => _lastTag;

  Future<void> getPostDetail(String id, {bool showLoading = true}) async {
    if (showLoading) {
      emit(const ForumState.loading());
    }
    final result = await _repository.getPostById(id);
    result.fold(
      (failure) {
        if (showLoading) emit(ForumState.error(failure.message));
      },
      (post) =>
          emit(ForumState.loaded([post])), // Simplified: reuse loaded state
    );
  }

  Future<void> toggleVote(
    String targetId,
    String targetType,
    String voteType, {
    String? postId,
  }) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final List<ForumPostEntity> oldPosts = List.from(currentState.posts);
    final List<ForumPostEntity> newPosts = currentState.posts.map((post) {
      if (targetType == 'POST' && post.id == targetId) {
        // Optimistic Update for Post
        int newUp = post.upvotes;
        int newDown = post.downvotes;
        String? newUserVote = voteType;

        if (post.userVote == voteType) {
          // Toggle OFF
          newUserVote = null;
          if (voteType == 'UP')
            newUp--;
          else
            newDown--;
        } else {
          // New vote or Switch
          if (voteType == 'UP') {
            newUp++;
            if (post.userVote == 'DOWN') newDown--;
          } else {
            newDown++;
            if (post.userVote == 'UP') newUp--;
          }
        }
        return post.copyWith(
          upvotes: newUp,
          downvotes: newDown,
          userVote: newUserVote,
        );
      } else if (targetType == 'COMMENT' && post.comments != null) {
        // Optimistic Update for Comment inside Post
        final newComments = post.comments!.map((comment) {
          if (comment.id == targetId) {
            int newUp = comment.upvotes;
            int newDown = comment.downvotes;
            String? newUserVote = voteType;

            if (comment.userVote == voteType) {
              newUserVote = null;
              if (voteType == 'UP')
                newUp--;
              else
                newDown--;
            } else {
              if (voteType == 'UP') {
                newUp++;
                if (comment.userVote == 'DOWN') newDown--;
              } else {
                newDown++;
                if (comment.userVote == 'UP') newUp--;
              }
            }
            return comment.copyWith(
              upvotes: newUp,
              downvotes: newDown,
              userVote: newUserVote,
            );
          }
          return comment;
        }).toList();
        return post.copyWith(comments: newComments);
      }
      return post;
    }).toList();

    // 1. Emit Optimistic State
    emit(ForumState.loaded(newPosts));

    // 2. Perform Backend Vote
    final result = await _repository.vote(targetId, targetType, voteType);

    result.fold(
      (failure) {
        // 3. Rollback on Failure
        emit(ForumState.loaded(oldPosts));
      },
      (_) {
        // 4. Final Sync (Silent)
        if (postId != null) {
          getPostDetail(postId, showLoading: false);
        } else {
          getPosts(showLoading: false);
        }
      },
    );
  }

  Future<void> createPost(
    String title,
    String content,
    String? categoryId, {
    String? groupId,
    List<ForumMediaAttachment> attachments = const [],
    String? status,
    List<String>? tags,
  }) async {
    emit(const ForumState.loading());

    List<ForumMediaItem>? media;
    if (attachments.isNotEmpty) {
      final upload = await _repository.uploadMedia(attachments);
      String? uploadError;
      upload.fold(
        (failure) => uploadError = failure.message,
        (items) => media = items,
      );
      if (uploadError != null) {
        emit(ForumState.error(uploadError!));
        return;
      }
    }

    final result = await _repository.createPost(
      title,
      content,
      categoryId,
      groupId: groupId,
      mediaUrls: media,
      status: status,
      tags: tags,
    );
    result.fold(
      (failure) => emit(ForumState.error(failure.message)),
      (_) => emit(const ForumState.success()),
    );
  }

  /// Edit / ubah status postingan milik sendiri.
  ///
  /// `existingMedia` adalah media yang sudah ada di server dan ingin
  /// dipertahankan; `newAttachments` adalah file lokal baru yang harus
  /// di-upload dulu sebelum di-merge.
  Future<void> updatePost(
    String id, {
    String? title,
    String? content,
    String? categoryId,
    List<ForumMediaItem>? existingMedia,
    List<ForumMediaAttachment> newAttachments = const [],
    String? status,
    List<String>? tags,
  }) async {
    emit(const ForumState.loading());

    List<ForumMediaItem>? mergedMedia;
    if (existingMedia != null || newAttachments.isNotEmpty) {
      mergedMedia = [...?existingMedia];
      if (newAttachments.isNotEmpty) {
        final upload = await _repository.uploadMedia(newAttachments);
        String? uploadError;
        upload.fold(
          (failure) => uploadError = failure.message,
          (items) => mergedMedia!.addAll(items),
        );
        if (uploadError != null) {
          emit(ForumState.error(uploadError!));
          return;
        }
      }
    }

    final result = await _repository.updatePost(
      id,
      title: title,
      content: content,
      categoryId: categoryId,
      mediaUrls: mergedMedia,
      status: status,
      tags: tags,
    );
    result.fold(
      (failure) => emit(ForumState.error(failure.message)),
      (_) => emit(const ForumState.success()),
    );
  }

  /// Soft-delete postingan (backend mengubah status jadi ARCHIVED).
  /// Optimistically remove dari list yang sedang loaded.
  Future<bool> deletePost(String id) async {
    final result = await _repository.deletePost(id);
    return result.fold(
      (failure) {
        emit(ForumState.error(failure.message));
        return false;
      },
      (_) {
        final current = state;
        if (current is _Loaded) {
          emit(
            ForumState.loaded(current.posts.where((p) => p.id != id).toList()),
          );
        }
        return true;
      },
    );
  }

  /// Ambil postingan milik user sendiri (untuk halaman manajemen).
  /// Status `null` → semua status.
  Future<void> getMyPosts({String? status, bool showLoading = true}) async {
    if (showLoading) emit(const ForumState.loading());
    final result = await _repository.getMyPosts(status: status);
    result.fold(
      (failure) => emit(ForumState.error(failure.message)),
      (posts) => emit(ForumState.loaded(posts)),
    );
  }

  Future<String?> addComment(
    String postId,
    String content, {
    String? parentId,
    List<ForumMediaAttachment> attachments = const [],
  }) async {
    final currentState = state;
    final previousPosts = currentState is _Loaded
        ? List<ForumPostEntity>.from(currentState.posts)
        : null;

    List<ForumMediaItem>? media;
    if (attachments.isNotEmpty) {
      final upload = await _repository.uploadMedia(attachments);
      String? uploadError;
      upload.fold(
        (failure) => uploadError = failure.message,
        (items) => media = items,
      );
      if (uploadError != null) {
        if (previousPosts != null) {
          emit(ForumState.loaded(previousPosts));
        }
        return uploadError;
      }
    }

    final createResult = await _repository.createComment(
      postId,
      content,
      parentId: parentId,
      mediaUrls: media,
    );

    String? createError;
    createResult.fold(
      (failure) => createError = failure.message,
      (_) {},
    );
    if (createError != null) {
      if (previousPosts != null) {
        emit(ForumState.loaded(previousPosts));
      }
      return createError;
    }

    final refresh = await _repository.getPostById(postId);
    return refresh.fold(
      (failure) {
        if (previousPosts != null) {
          emit(ForumState.loaded(previousPosts));
        }
        return failure.message;
      },
      (post) {
        emit(ForumState.loaded([post]));
        return null;
      },
    );
  }

  Future<void> getCategories() async {
    final result = await _repository.getCategories(type: 'FORUM');
    result.fold(
      (failure) => emit(ForumState.error(failure.message)),
      (categories) => emit(ForumState.categoriesLoaded(categories)),
    );
  }
}
