class FollowUserEntity {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String? province;
  final String? regency;
  final bool isVerified;

  const FollowUserEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.role = 'SUPPLIER',
    this.province,
    this.regency,
    this.isVerified = false,
  });
}

class FollowStatsEntity {
  final String userId;
  final int followingCount;
  final int followersCount;

  const FollowStatsEntity({
    required this.userId,
    this.followingCount = 0,
    this.followersCount = 0,
  });

  FollowStatsEntity copyWith({
    int? followingCount,
    int? followersCount,
  }) {
    return FollowStatsEntity(
      userId: userId,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
    );
  }
}
