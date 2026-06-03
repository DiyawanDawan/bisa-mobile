import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../data/datasources/commerce_remote_data_source.dart';

class CartSummary {
  final List<CartItemModel> items;
  final int count;
  final double totalAmount;

  CartSummary({
    required this.items,
    required this.count,
    required this.totalAmount,
  });
}

abstract class CommerceRepository {
  Future<Either<Failure, CartSummary>> getCart();
  Future<Either<Failure, int>> getCartCount();
  Future<Either<Failure, CartSummary>> addToCart(String productId, double quantity);
  Future<Either<Failure, CartSummary>> updateCartItem(String cartItemId, double quantity);
  Future<Either<Failure, CartSummary>> removeCartItem(String cartItemId);
  Future<Either<Failure, CartSummary>> clearCart();
  Future<Either<Failure, List<String>>> getWishlistIds();
  Future<Either<Failure, List<ProductEntity>>> getWishlist();
  Future<Either<Failure, bool>> toggleLike(String productId);
}
