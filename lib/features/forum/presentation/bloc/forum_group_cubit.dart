import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/forum_group_entity.dart';
import '../../domain/repositories/forum_group_repository.dart';

sealed class ForumGroupState {
  const ForumGroupState();
}

class ForumGroupInitial extends ForumGroupState {
  const ForumGroupInitial();
}

class ForumGroupLoading extends ForumGroupState {
  const ForumGroupLoading();
}

class ForumGroupListLoaded extends ForumGroupState {
  final List<ForumGroupEntity> groups;
  final bool mine;
  const ForumGroupListLoaded(this.groups, {this.mine = false});
}

class ForumGroupDetailLoaded extends ForumGroupState {
  final ForumGroupEntity group;
  const ForumGroupDetailLoaded(this.group);
}

class ForumGroupSuccess extends ForumGroupState {
  final ForumGroupEntity? group;
  const ForumGroupSuccess({this.group});
}

class ForumGroupError extends ForumGroupState {
  final String message;
  const ForumGroupError(this.message);
}

class ForumGroupCubit extends Cubit<ForumGroupState> {
  final ForumGroupRepository _repository;

  ForumGroupCubit(this._repository) : super(const ForumGroupInitial());

  Future<void> loadGroups({String? keyword, bool mine = false}) async {
    emit(const ForumGroupLoading());
    final result = await _repository.getGroups(keyword: keyword, mine: mine);
    result.fold(
      (f) => emit(ForumGroupError(f.message)),
      (groups) => emit(ForumGroupListLoaded(groups, mine: mine)),
    );
  }

  Future<void> loadGroupDetail(String id) async {
    emit(const ForumGroupLoading());
    final result = await _repository.getGroupById(id);
    result.fold(
      (f) => emit(ForumGroupError(f.message)),
      (group) => emit(ForumGroupDetailLoaded(group)),
    );
  }

  Future<ForumGroupEntity?> createGroup({
    required String name,
    String? description,
    String? avatarPath,
    String? bannerPath,
    bool isPublic = true,
  }) async {
    emit(const ForumGroupLoading());
    String? avatarUrl;
    String? bannerUrl;

    if (avatarPath != null) {
      final upload = await _repository.uploadImage(avatarPath);
      String? err;
      upload.fold((f) => err = f.message, (url) {
        final cleaned = url.trim();
        if (cleaned.isEmpty) {
          err = 'Upload avatar gagal: URL kosong.';
        } else {
          avatarUrl = cleaned;
        }
      });
      if (err != null) {
        emit(ForumGroupError(err!));
        return null;
      }
    }
    if (bannerPath != null) {
      final upload = await _repository.uploadImage(bannerPath);
      String? err;
      upload.fold((f) => err = f.message, (url) {
        final cleaned = url.trim();
        if (cleaned.isEmpty) {
          err = 'Upload banner gagal: URL kosong.';
        } else {
          bannerUrl = cleaned;
        }
      });
      if (err != null) {
        emit(ForumGroupError(err!));
        return null;
      }
    }

    final result = await _repository.createGroup(
      name: name,
      description: description,
      avatarUrl: avatarUrl,
      bannerUrl: bannerUrl,
      isPublic: isPublic,
    );
    return result.fold(
      (f) {
        emit(ForumGroupError(f.message));
        return null;
      },
      (group) {
        emit(ForumGroupSuccess(group: group));
        return group;
      },
    );
  }

  Future<bool> joinGroup(String id) async {
    final result = await _repository.joinGroup(id);
    return result.fold(
      (f) {
        emit(ForumGroupError(f.message));
        return false;
      },
      (group) {
        emit(ForumGroupDetailLoaded(group));
        return true;
      },
    );
  }

  Future<bool> leaveGroup(String id) async {
    final result = await _repository.leaveGroup(id);
    return result.fold(
      (f) {
        emit(ForumGroupError(f.message));
        return false;
      },
      (_) {
        final current = state;
        if (current is ForumGroupDetailLoaded) {
          emit(
            ForumGroupDetailLoaded(
              current.group.copyWith(
                isMember: false,
                myRole: null,
                memberCount: (current.group.memberCount - 1).clamp(0, 999999),
              ),
            ),
          );
        }
        return true;
      },
    );
  }
}
