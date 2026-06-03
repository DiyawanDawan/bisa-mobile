class StoreBannerModel {
  final String id;
  final String imageUrl;
  final String? title;
  final int sortOrder;
  final bool isActive;

  const StoreBannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory StoreBannerModel.fromJson(Map<String, dynamic> json) {
    return StoreBannerModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
