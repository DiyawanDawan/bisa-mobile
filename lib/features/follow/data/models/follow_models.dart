class FollowUserModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String? province;
  final String? regency;
  final bool isVerified;

  FollowUserModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.province,
    this.regency,
    this.isVerified = false,
  });

  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'SUPPLIER',
      province: json['province'] as String?,
      regency: json['regency'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}

class FollowStatsModel {
  final String userId;
  final int followingCount;
  final int followersCount;

  FollowStatsModel({
    required this.userId,
    required this.followingCount,
    required this.followersCount,
  });

  factory FollowStatsModel.fromJson(Map<String, dynamic> json) {
    return FollowStatsModel(
      userId: json['userId'] as String,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class FollowListModel {
  final List<FollowUserModel> users;
  final int total;

  FollowListModel({required this.users, required this.total});

  factory FollowListModel.fromJson(Map<String, dynamic> json) {
    final raw = json['users'] as List? ?? [];
    return FollowListModel(
      users: raw
          .map((e) => FollowUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? raw.length,
    );
  }
}
