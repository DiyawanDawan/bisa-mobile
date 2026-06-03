import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/follow_user_entity.dart';
import '../../domain/repositories/follow_repository.dart';

class FollowState extends Equatable {
  final Set<String> followingIds;
  final FollowStatsEntity? myStats;
  final List<FollowUserEntity> followingUsers;
  final List<FollowUserEntity> followerUsers;
  final bool isLoading;
  final String? error;

  const FollowState({
    this.followingIds = const {},
    this.myStats,
    this.followingUsers = const [],
    this.followerUsers = const [],
    this.isLoading = false,
    this.error,
  });

  bool isFollowing(String userId) => followingIds.contains(userId);

  FollowState copyWith({
    Set<String>? followingIds,
    FollowStatsEntity? myStats,
    List<FollowUserEntity>? followingUsers,
    List<FollowUserEntity>? followerUsers,
    bool? isLoading,
    String? error,
  }) {
    return FollowState(
      followingIds: followingIds ?? this.followingIds,
      myStats: myStats ?? this.myStats,
      followingUsers: followingUsers ?? this.followingUsers,
      followerUsers: followerUsers ?? this.followerUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        followingIds,
        myStats,
        followingUsers,
        followerUsers,
        isLoading,
        error,
      ];
}

class FollowCubit extends Cubit<FollowState> {
  final FollowRepository _repository;

  FollowCubit(this._repository) : super(const FollowState());

  Future<void> bootstrap(String? currentUserId) async {
    if (currentUserId == null) return;
    await Future.wait([
      loadFollowingIds(),
      loadMyStats(currentUserId),
    ]);
  }

  Future<void> loadFollowingIds() async {
    final result = await _repository.getMyFollowingIds();
    result.fold(
      (_) {},
      (ids) => emit(state.copyWith(followingIds: ids.toSet())),
    );
  }

  Future<void> loadMyStats(String userId) async {
    final result = await _repository.getFollowStats(userId);
    result.fold(
      (_) {},
      (stats) => emit(state.copyWith(myStats: stats)),
    );
  }

  Future<void> loadFollowingList({String? userId}) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.getFollowing(userId: userId);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (users) => emit(state.copyWith(isLoading: false, followingUsers: users)),
    );
  }

  Future<void> loadFollowersList({String? userId}) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.getFollowers(userId: userId);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (users) => emit(state.copyWith(isLoading: false, followerUsers: users)),
    );
  }

  Future<bool> toggleFollow(String userId, {String? currentUserId}) async {
    final result = await _repository.toggleFollow(userId);
    return result.fold(
      (f) {
        emit(state.copyWith(error: f.message));
        return state.isFollowing(userId);
      },
      (following) {
        final updated = Set<String>.from(state.followingIds);
        if (following) {
          updated.add(userId);
        } else {
          updated.remove(userId);
        }
        emit(state.copyWith(followingIds: updated));

        if (currentUserId != null && state.myStats != null) {
          final stats = state.myStats!;
          emit(
            state.copyWith(
              myStats: stats.copyWith(
                followingCount: following
                    ? stats.followingCount + 1
                    : (stats.followingCount > 0 ? stats.followingCount - 1 : 0),
              ),
            ),
          );
        }
        return following;
      },
    );
  }

  Future<void> ensureFollowingStatus(String userId) async {
    if (state.followingIds.isNotEmpty || state.isFollowing(userId)) return;
    final result = await _repository.checkIsFollowing(userId);
    result.fold((_) {}, (isFollowing) {
      if (!isFollowing) return;
      emit(state.copyWith(followingIds: {...state.followingIds, userId}));
    });
  }

  void reset() {
    emit(const FollowState());
  }
}
