import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';

enum MarketChartRange { oneMonth, threeMonths, all }

abstract class MarketTrendMetrics {
  MarketTrendMetrics._();

  static double percentChange(MarketTrendModel trend) {
    if (trend.historyData.length < 2) return 0;
    final current = trend.historyData.last.y;
    final previous = trend.historyData[trend.historyData.length - 2].y;
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  static String formatPercent(double value) {
    if (value > 0) return '+${value.abs().toStringAsFixed(1)}%';
    if (value < 0) return '-${value.abs().toStringAsFixed(1)}%';
    return '0.0%';
  }

  static Color trendColor(String trendType) {
    if (trendType == 'UP') return AppColors.success;
    if (trendType == 'STABLE') return AppColors.warning;
    return AppColors.error;
  }

  static Color trendColorFromChange(double change) {
    if (change > 0.05) return AppColors.success;
    if (change < -0.05) return AppColors.error;
    return AppColors.warning;
  }

  static IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cangkang sawit':
        return LucideIcons.nut;
      case 'kayu':
        return LucideIcons.treePine;
      case 'sekam padi':
        return LucideIcons.wheat;
      default:
        return LucideIcons.leaf;
    }
  }

  static List<String> categories(List<MarketTrendModel> trends) {
    final set = <String>{};
    for (final t in trends) {
      if (t.category.trim().isNotEmpty) set.add(t.category);
    }
    return set.toList()..sort();
  }

  static List<MarketTrendModel> filterByCategory(
    List<MarketTrendModel> trends,
    String? category,
  ) {
    if (category == null || category.isEmpty) return trends;
    return trends.where((t) => t.category == category).toList();
  }

  static List<MarketTrendModel> sortedByChange(
    List<MarketTrendModel> trends, {
    bool descending = true,
  }) {
    final copy = List<MarketTrendModel>.from(trends);
    copy.sort((a, b) {
      final cmp = percentChange(a).compareTo(percentChange(b));
      return descending ? -cmp : cmp;
    });
    return copy;
  }

  static List<MarketTrendModel> gainers(
    List<MarketTrendModel> trends, {
    int limit = 4,
  }) {
    return sortedByChange(trends)
        .where((t) => percentChange(t) > 0)
        .take(limit)
        .toList();
  }

  static List<MarketTrendModel> losers(
    List<MarketTrendModel> trends, {
    int limit = 4,
  }) {
    return sortedByChange(trends, descending: false)
        .where((t) => percentChange(t) < 0)
        .take(limit)
        .toList();
  }

  static MarketTrendModel? topMover(List<MarketTrendModel> trends) {
    if (trends.isEmpty) return null;
    return sortedByChange(trends).first;
  }

  static double averageChange(List<MarketTrendModel> trends) {
    if (trends.isEmpty) return 0;
    final sum = trends.fold<double>(0, (s, t) => s + percentChange(t));
    return sum / trends.length;
  }

  static int countUp(List<MarketTrendModel> trends) =>
      trends.where((t) => t.trendType == 'UP').length;

  static int countDown(List<MarketTrendModel> trends) =>
      trends.where((t) => t.trendType == 'DOWN').length;

  static List<MarketDataPointModel> sliceHistory(
    List<MarketDataPointModel> history,
    MarketChartRange range,
  ) {
    if (history.isEmpty) return history;
    switch (range) {
      case MarketChartRange.oneMonth:
        return history.length <= 4 ? history : history.sublist(history.length - 4);
      case MarketChartRange.threeMonths:
        return history.length <= 12
            ? history
            : history.sublist(history.length - 12);
      case MarketChartRange.all:
        return history;
    }
  }

  static MarketTrendModel? featuredTrend(List<MarketTrendModel> trends) {
    if (trends.isEmpty) return null;
    return topMover(trends) ?? trends.first;
  }
}
