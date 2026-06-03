import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/market_repository.dart';
import '../datasources/market_remote_data_source.dart';
import '../models/market_trend_model.dart';

class MarketRepositoryImpl implements MarketRepository {
  final MarketRemoteDataSource remoteDataSource;

  MarketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MarketTrendModel>>> getMarketTrends({
    String? category,
  }) async {
    try {
      final result = await remoteDataSource.getMarketTrends(category: category);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, MarketTrendModel>> getPrediction(String id) async {
    try {
      final result = await remoteDataSource.getPrediction(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _handleDioError(DioException e) {
    final message =
        e.response?.data?['meta']?['message'] ??
        e.message ??
        'Terjadi kesalahan';
    return ServerFailure(message: message);
  }
}
