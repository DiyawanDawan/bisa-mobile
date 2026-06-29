class ProductEngagementItem {
  final String productId;
  final String name;
  final String? thumbnailUrl;
  final double pricePerUnit;
  final String unit;
  final int totalSold;
  final String status;
  final int likeCount;
  final int cartCount;

  const ProductEngagementItem({
    required this.productId,
    required this.name,
    this.thumbnailUrl,
    required this.pricePerUnit,
    required this.unit,
    required this.totalSold,
    required this.status,
    required this.likeCount,
    required this.cartCount,
  });

  factory ProductEngagementItem.fromJson(Map<String, dynamic> json) {
    return ProductEngagementItem(
      productId: json['productId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'marketplace.unnamed_product',
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      pricePerUnit: double.tryParse(json['pricePerUnit']?.toString() ?? '') ?? 0,
      unit: json['unit']?.toString() ?? 'unit',
      totalSold: (json['totalSold'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'ACTIVE',
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      cartCount: (json['cartCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductEngagementSummary {
  final int totalLikes;
  final int totalInCart;
  final int productCount;

  const ProductEngagementSummary({
    required this.totalLikes,
    required this.totalInCart,
    required this.productCount,
  });

  factory ProductEngagementSummary.fromJson(Map<String, dynamic> json) {
    return ProductEngagementSummary(
      totalLikes: (json['totalLikes'] as num?)?.toInt() ?? 0,
      totalInCart: (json['totalInCart'] as num?)?.toInt() ?? 0,
      productCount: (json['productCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductEngagementData {
  final ProductEngagementSummary summary;
  final List<ProductEngagementItem> topLiked;
  final List<ProductEngagementItem> topInCart;

  const ProductEngagementData({
    required this.summary,
    required this.topLiked,
    required this.topInCart,
  });

  factory ProductEngagementData.fromJson(Map<String, dynamic> json) {
    List<ProductEngagementItem> parseList(dynamic raw) {
      if (raw is! List) return [];
      return raw
          .map((e) => ProductEngagementItem.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    }

    return ProductEngagementData(
      summary: ProductEngagementSummary.fromJson(
        Map<String, dynamic>.from(json['summary'] as Map? ?? {}),
      ),
      topLiked: parseList(json['topLiked']),
      topInCart: parseList(json['topInCart']),
    );
  }
}
