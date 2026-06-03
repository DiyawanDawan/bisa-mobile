import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_trend_model.freezed.dart';
part 'market_trend_model.g.dart';

@freezed
abstract class MarketTrendModel with _$MarketTrendModel {
  const factory MarketTrendModel({
    required String id,
    required String label,
    required String category,
    required String currentValue,
    required String trendType, // UP, DOWN, STABLE
    required List<MarketDataPointModel> historyData,
    List<MarketDataPointModel>? projectedData,
    String? insight,
  }) = _MarketTrendModel;

  factory MarketTrendModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing for historyData
    var historyRaw = json['historyData'];
    List<MarketDataPointModel> history = [];
    
    if (historyRaw is String) {
      try {
        // Try to decode if it's a string
        final decoded = jsonDecode(historyRaw);
        if (decoded is List) {
          historyRaw = decoded;
        }
      } catch (_) {}
    }
    
    if (historyRaw is List) {
      for (var item in historyRaw) {
        if (item is Map<String, dynamic> && item.containsKey('x') && item.containsKey('y')) {
          history.add(MarketDataPointModel.fromJson(item));
        }
      }
    }

    return MarketTrendModel(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      currentValue: json['currentValue']?.toString() ?? '',
      trendType: json['trendType']?.toString() ?? 'STABLE',
      historyData: history,
      projectedData: json['projectedData'] != null ? (json['projectedData'] as List).map((e) => MarketDataPointModel.fromJson(e)).toList() : null,
      insight: json['insight']?.toString(),
    );
  }
}

@freezed
abstract class MarketDataPointModel with _$MarketDataPointModel {
  const factory MarketDataPointModel({
    required String x, // Date string
    required num y, // Value
  }) = _MarketDataPointModel;

  factory MarketDataPointModel.fromJson(Map<String, dynamic> json) =>
      _$MarketDataPointModelFromJson(json);
}
