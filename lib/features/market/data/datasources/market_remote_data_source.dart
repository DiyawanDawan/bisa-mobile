import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/market_supply_demand_model.dart';
import '../models/market_trend_model.dart';

abstract class MarketRemoteDataSource {
  Future<List<MarketTrendModel>> getMarketTrends({String? category});
  Future<MarketTrendModel> getPrediction(String id);
  Future<MarketSupplyDemandOverviewModel> getSupplyDemandOverview();
}

class MarketRemoteDataSourceImpl implements MarketRemoteDataSource {
  final Dio dio;

  MarketRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MarketTrendModel>> getMarketTrends({String? category}) async {
    try {
      final response = await dio.get(
        '/market/trends',
        queryParameters: {if (category != null) 'category': category},
      );

      dynamic body = response.data;
      if (body is String) body = jsonDecode(body);

      final List? data = body['data'] as List?;
      if (data == null) return [];

      return data.map((e) => MarketTrendModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('MarketRemoteDataSource Error: $e');
      rethrow;
    }
  }

  @override
  Future<MarketTrendModel> getPrediction(String id) async {
    try {
      final response = await dio.get('/market/prediction/$id');
      dynamic body = response.data;
      if (body is String) body = jsonDecode(body);

      return MarketTrendModel.fromJson(body['data']);
    } catch (e) {
      debugPrint('MarketRemoteDataSource Error: $e');
      rethrow;
    }
  }

  @override
  Future<MarketSupplyDemandOverviewModel> getSupplyDemandOverview() async {
    try {
      final response = await dio.get('/market/supply-demand');
      dynamic body = response.data;
      if (body is String) body = jsonDecode(body);
      return MarketSupplyDemandOverviewModel.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
      );
    } catch (e) {
      debugPrint('MarketRemoteDataSource supply-demand Error: $e');
      rethrow;
    }
  }
}
