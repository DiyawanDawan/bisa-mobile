import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../domain/repositories/commerce_repository.dart';
import '../datasources/commerce_remote_data_source.dart';

class CommerceRepositoryImpl implements CommerceRepository {
  final CommerceRemoteDataSource remoteDataSource;

  CommerceRepositoryImpl({required this.remoteDataSource});

  CartSummary _parseCart(Map<String, dynamic> data) {
    final items = (data['items'] as List? ?? [])
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return CartSummary(
      items: items,
      count: (data['count'] as num?)?.toInt() ?? items.length,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  Future<Either<Failure, CartSummary>> getCart() async {
    try {
      final data = await remoteDataSource.getCart();
      return Right(_parseCart(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getCartCount() async {
    try {
      return Right(await remoteDataSource.getCartCount());
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, CartSummary>> addToCart(
    String productId,
    double quantity,
  ) async {
    try {
      final data = await remoteDataSource.addToCart(productId, quantity);
      return Right(_parseCart(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, CartSummary>> updateCartItem(
    String cartItemId,
    double quantity,
  ) async {
    try {
      final data = await remoteDataSource.updateCartItem(cartItemId, quantity);
      return Right(_parseCart(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, CartSummary>> removeCartItem(String cartItemId) async {
    try {
      final data = await remoteDataSource.removeCartItem(cartItemId);
      return Right(_parseCart(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, CartSummary>> clearCart() async {
    try {
      final data = await remoteDataSource.clearCart();
      return Right(_parseCart(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getWishlistIds() async {
    try {
      return Right(await remoteDataSource.getWishlistIds());
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getWishlist() async {
    try {
      final models = await remoteDataSource.getWishlist();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleLike(String productId) async {
    try {
      return Right(await remoteDataSource.toggleLike(productId));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDio(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['meta']?['message'] ?? data['message'] ?? 'errors.generic')
          : 'errors.generic';
      return ServerFailure(message: message.toString(), statusCode: e.response?.statusCode);
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }
}
