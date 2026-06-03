import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/market_trend_model.dart';

abstract class MarketRepository {
  Future<Either<Failure, List<MarketTrendModel>>> getMarketTrends({String? category});
  Future<Either<Failure, MarketTrendModel>> getPrediction(String id);
}
