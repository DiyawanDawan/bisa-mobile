import '../../domain/entities/product_stats_entity.dart';

class ProductStatsModel {
  final int viewCount;
  final int totalSold;
  final int activeNegotiations;
  final int totalReviews;
  final double averageRating;

  const ProductStatsModel({
    required this.viewCount,
    required this.totalSold,
    required this.activeNegotiations,
    required this.totalReviews,
    required this.averageRating,
  });

  factory ProductStatsModel.fromJson(Map<String, dynamic> json) {
    return ProductStatsModel(
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      totalSold: (json['totalSold'] as num?)?.toInt() ?? 0,
      activeNegotiations: (json['activeNegotiations'] as num?)?.toInt() ?? 0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
    );
  }

  ProductStatsEntity toEntity() => ProductStatsEntity(
        viewCount: viewCount,
        totalSold: totalSold,
        activeNegotiations: activeNegotiations,
        totalReviews: totalReviews,
        averageRating: averageRating,
      );
}
