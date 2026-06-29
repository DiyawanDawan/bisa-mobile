class ForumGroupOwnerEntity {
  final String id;
  final String fullName;
  final String? avatarUrl;

  const ForumGroupOwnerEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  factory ForumGroupOwnerEntity.fromJson(Map<String, dynamic> json) {
    return ForumGroupOwnerEntity(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? 'Pengguna',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

class ForumGroupEntity {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? avatarUrl;
  final String? bannerUrl;
  final bool isPublic;
  final int memberCount;
  final int postCount;
  final DateTime createdAt;
  final ForumGroupOwnerEntity owner;
  final bool isMember;
  final String? myRole;

  const ForumGroupEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.avatarUrl,
    this.bannerUrl,
    this.isPublic = true,
    this.memberCount = 0,
    this.postCount = 0,
    required this.createdAt,
    required this.owner,
    this.isMember = false,
    this.myRole,
  });

  factory ForumGroupEntity.fromJson(Map<String, dynamic> json) {
    return ForumGroupEntity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      bannerUrl: json['bannerUrl']?.toString(),
      isPublic: json['isPublic'] == true || json['isPublic'] == null,
      memberCount: _asInt(json['memberCount']),
      postCount: _asInt(json['postCount']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      owner: ForumGroupOwnerEntity.fromJson(
        Map<String, dynamic>.from(json['owner'] as Map? ?? const {}),
      ),
      isMember: json['isMember'] == true,
      myRole: json['myRole']?.toString(),
    );
  }

  ForumGroupEntity copyWith({
    bool? isMember,
    String? myRole,
    int? memberCount,
  }) {
    return ForumGroupEntity(
      id: id,
      name: name,
      slug: slug,
      description: description,
      avatarUrl: avatarUrl,
      bannerUrl: bannerUrl,
      isPublic: isPublic,
      memberCount: memberCount ?? this.memberCount,
      postCount: postCount,
      createdAt: createdAt,
      owner: owner,
      isMember: isMember ?? this.isMember,
      myRole: myRole ?? this.myRole,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
