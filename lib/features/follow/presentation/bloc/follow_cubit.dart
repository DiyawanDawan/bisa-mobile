import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_bisa/core/errors/failures.dart';
import '../../domain/entities/follow_user_entity.dart';
import '../../domain/repositories/follow_repository.dart';

class FollowState extends Equatable {
  final Set<String> followingIds;
  final bool followingIdsLoaded;
  final FollowStatsEntity? myStats;
  final Map<String, FollowStatsEntity> statsByUserId;
  final List<FollowUserEntity> followingUsers;
  final List<FollowUserEntity> followerUsers;
  final bool isLoading;
  final String? error;

  const FollowState({
    this.followingIds = const {},
    this.followingIdsLoaded = false,
    this.myStats,
    this.statsByUserId = const {},
    this.followingUsers = const [],
    this.followerUsers = const [],
    this.isLoading = false,
    this.error,
  });

  bool isFollowing(String userId) => followingIds.contains(userId);

  FollowStatsEntity? statsForUser(String userId) => statsByUserId[userId];

  FollowState copyWith({
    Set<String>? followingIds,
    bool? followingIdsLoaded,
    FollowStatsEntity? myStats,
    Map<String, FollowStatsEntity>? statsByUserId,
    List<FollowUserEntity>? followingUsers,
    List<FollowUserEntity>? followerUsers,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FollowState(
      followingIds: followingIds ?? this.followingIds,
      followingIdsLoaded: followingIdsLoaded ?? this.followingIdsLoaded,
      myStats: myStats ?? this.myStats,
      statsByUserId: statsByUserId ?? this.statsByUserId,
      followingUsers: followingUsers ?? this.followingUsers,
      followerUsers: followerUsers ?? this.followerUsers,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        followingIds,
        followingIdsLoaded,
        myStats,
        statsByUserId,
        followingUsers,
        followerUsers,
        isLoading,
        error,
      ];
}

class FollowCubit extends Cubit<FollowState> {
  final FollowRepository _repository;
  final Set<String> _ensureStatusInFlight = {};

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
      (ids) => emit(
        state.copyWith(
          followingIds: ids.toSet(),
          followingIdsLoaded: true,
        ),
      ),
    );
  }

  Future<void> loadMyStats(String userId) async {
    final result = await _repository.getFollowStats(userId);
    result.fold(
      (_) {},
      (stats) => emit(state.copyWith(myStats: stats)),
    );
  }

  Future<void> loadFollowStatsForUser(String userId) async {
    if (state.statsByUserId.containsKey(userId)) return;
    final result = await _repository.getFollowStats(userId);
    result.fold(
      (_) {},
      (stats) => emit(
        state.copyWith(
          statsByUserId: {...state.statsByUserId, userId: stats},
        ),
      ),
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

  /// Returns error message on failure, null on success.
  Future<String?> toggleFollow(String userId, {String? currentUserId}) async {
    final result = await _repository.toggleFollow(userId);
    return result.fold(
      (f) {
        emit(state.copyWith(error: f.message));
        return f.message;
      },
      (following) {
        final updated = Set<String>.from(state.followingIds);
        if (following) {
          updated.add(userId);
        } else {
          updated.remove(userId);
        }
        emit(state.copyWith(followingIds: updated, clearError: true));

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

        final viewed = state.statsByUserId[userId];
        if (viewed != null) {
          final nextFollowers = following
              ? viewed.followersCount + 1
              : (viewed.followersCount > 0 ? viewed.followersCount - 1 : 0);
          emit(
            state.copyWith(
              statsByUserId: {
                ...state.statsByUserId,
                userId: viewed.copyWith(followersCount: nextFollowers),
              },
            ),
          );
        }
        return null;
      },
    );
  }

  Future<void> ensureFollowingStatus(String userId) async {
    if (state.isFollowing(userId)) return;
    if (state.followingIdsLoaded) return;
    if (_ensureStatusInFlight.contains(userId)) return;
    _ensureStatusInFlight.add(userId);
    try {
      final result = await _repository.checkIsFollowing(userId);
      result.fold((_) {}, (isFollowing) {
        if (!isFollowing) return;
        emit(state.copyWith(followingIds: {...state.followingIds, userId}));
      });
    } finally {
      _ensureStatusInFlight.remove(userId);
    }
  }

  void reset() {
    _ensureStatusInFlight.clear();
    emit(const FollowState());
  }
}
