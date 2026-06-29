class MarketSupplyDemandModel {
  final String label;
  final String balance;
  final int productCount;
  final int listingCount;
  final int totalStockKg;
  final double totalStockTon;
  final int provinceCount;
  final int orderCount90d;
  final int openOrderCount;
  final int quantityKg90d;
  final double quantityTon90d;
  final int completedQuantityKg90d;
  final double? supplyDemandRatio;

  const MarketSupplyDemandModel({
    required this.label,
    required this.balance,
    required this.productCount,
    required this.listingCount,
    required this.totalStockKg,
    required this.totalStockTon,
    required this.provinceCount,
    required this.orderCount90d,
    required this.openOrderCount,
    required this.quantityKg90d,
    required this.quantityTon90d,
    required this.completedQuantityKg90d,
    this.supplyDemandRatio,
  });

  factory MarketSupplyDemandModel.fromJson(Map<String, dynamic> json) {
    final supply = json['supply'] as Map<String, dynamic>? ?? {};
    final demand = json['demand'] as Map<String, dynamic>? ?? {};
    return MarketSupplyDemandModel(
      label: json['label']?.toString() ?? '',
      balance: json['balance']?.toString() ?? 'unknown',
      productCount: _int(supply['productCount']),
      listingCount: _int(supply['listingCount']),
      totalStockKg: _int(supply['totalStockKg']),
      totalStockTon: _double(supply['totalStockTon'] ?? supply['readySupplyTon']),
      provinceCount: _int(supply['provinceCount']),
      orderCount90d: _int(demand['orderCount90d']),
      openOrderCount: _int(demand['openOrderCount']),
      quantityKg90d: _int(demand['quantityKg90d']),
      quantityTon90d: _double(demand['quantityTon90d']),
      completedQuantityKg90d: _int(demand['completedQuantityKg90d']),
      supplyDemandRatio: json['supplyDemandRatio'] == null
          ? null
          : double.tryParse(json['supplyDemandRatio'].toString()),
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.round();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  static double _double(dynamic v) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0;
  }
}

class MarketSupplyDemandOverviewModel {
  final List<MarketSupplyDemandModel> commodities;
  final int totalProductCount;
  final double totalStockTon;
  final double totalDemandTon90d;

  const MarketSupplyDemandOverviewModel({
    required this.commodities,
    required this.totalProductCount,
    required this.totalStockTon,
    required this.totalDemandTon90d,
  });

  factory MarketSupplyDemandOverviewModel.fromJson(Map<String, dynamic> json) {
    final totals = json['totals'] as Map<String, dynamic>? ?? {};
    final list = json['commodities'] as List? ?? [];
    return MarketSupplyDemandOverviewModel(
      commodities: list
          .whereType<Map<String, dynamic>>()
          .map(MarketSupplyDemandModel.fromJson)
          .toList(),
      totalProductCount: MarketSupplyDemandModel._int(totals['productCount']),
      totalStockTon: MarketSupplyDemandModel._double(totals['totalStockTon']),
      totalDemandTon90d: MarketSupplyDemandModel._double(totals['totalDemandTon90d']),
    );
  }
}
