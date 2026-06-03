import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/market_trend_model.dart';

abstract class MarketRemoteDataSource {
  Future<List<MarketTrendModel>> getMarketTrends({String? category});
  Future<MarketTrendModel> getPrediction(String id);
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
}
