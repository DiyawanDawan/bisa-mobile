import 'package:dio/dio.dart';
import 'package:mobile_bisa/features/marketplace/data/models/product_model.dart';

class CartItemModel {
  final String id;
  final double quantity;
  final ProductModel product;

  CartItemModel({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );
  }
}

abstract class CommerceRemoteDataSource {
  Future<Map<String, dynamic>> getCart();
  Future<int> getCartCount();
  Future<Map<String, dynamic>> addToCart(String productId, double quantity);
  Future<Map<String, dynamic>> updateCartItem(String cartItemId, double quantity);
  Future<Map<String, dynamic>> removeCartItem(String cartItemId);
  Future<Map<String, dynamic>> clearCart();
  Future<List<String>> getWishlistIds();
  Future<List<ProductModel>> getWishlist();
  Future<bool> toggleLike(String productId);
  Future<bool> isProductLiked(String productId);
}

class CommerceRemoteDataSourceImpl implements CommerceRemoteDataSource {
  final Dio dio;

  CommerceRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getCart() async {
    final response = await dio.get('/cart');
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<int> getCartCount() async {
    final response = await dio.get('/cart/count');
    final data = response.data['data'] as Map<String, dynamic>;
    return (data['count'] as num).toInt();
  }

  @override
  Future<Map<String, dynamic>> addToCart(String productId, double quantity) async {
    final response = await dio.post('/cart', data: {
      'productId': productId,
      'quantity': quantity,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateCartItem(
    String cartItemId,
    double quantity,
  ) async {
    final response = await dio.patch('/cart/$cartItemId', data: {
      'quantity': quantity,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> removeCartItem(String cartItemId) async {
    final response = await dio.delete('/cart/$cartItemId');
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> clearCart() async {
    final response = await dio.delete('/cart/clear');
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<List<String>> getWishlistIds() async {
    final response = await dio.get('/wishlist/ids');
    final data = response.data['data'] as Map<String, dynamic>;
    return List<String>.from(data['productIds'] as List);
  }

  @override
  Future<List<ProductModel>> getWishlist() async {
    final response = await dio.get('/wishlist');
    final data = response.data['data'] as Map<String, dynamic>;
    final products = data['products'] as List;
    return products
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> toggleLike(String productId) async {
    final response = await dio.post('/wishlist/toggle', data: {
      'productId': productId,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    return data['liked'] as bool;
  }

  @override
  Future<bool> isProductLiked(String productId) async {
    final response = await dio.get('/wishlist/check/$productId');
    final data = response.data['data'] as Map<String, dynamic>;
    return data['liked'] as bool;
  }
}
