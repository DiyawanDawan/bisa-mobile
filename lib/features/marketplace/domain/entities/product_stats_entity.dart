class ProductStatsEntity {
  final int viewCount;
  final int totalSold;
  final int activeNegotiations;
  final int totalReviews;
  final double averageRating;

  const ProductStatsEntity({
    required this.viewCount,
    required this.totalSold,
    required this.activeNegotiations,
    required this.totalReviews,
    required this.averageRating,
  });
}
