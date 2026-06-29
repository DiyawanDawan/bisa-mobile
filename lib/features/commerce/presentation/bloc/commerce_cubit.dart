import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../domain/repositories/commerce_repository.dart';
import '../../data/datasources/commerce_remote_data_source.dart';

class CommerceState extends Equatable {
  final int cartCount;
  final Set<String> likedIds;
  final CartSummary? cart;
  final List<ProductEntity>? wishlistProducts;
  final bool isLoading;
  final String? error;

  const CommerceState({
    this.cartCount = 0,
    this.likedIds = const {},
    this.cart,
    this.wishlistProducts,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [cartCount, likedIds, cart, wishlistProducts, isLoading, error];
}

class CommerceCubit extends Cubit<CommerceState> {
  final CommerceRepository _repository;

  CommerceCubit(this._repository) : super(const CommerceState());

  bool isLiked(String productId) => state.likedIds.contains(productId);

  Future<void> bootstrap() async {
    emit(CommerceState(isLoading: true, likedIds: state.likedIds, cartCount: state.cartCount));
    final cartResult = await _repository.getCartCount();
    final wishResult = await _repository.getWishlistIds();

    var count = 0;
    var ids = <String>{};
    cartResult.fold((_) {}, (c) => count = c);
    wishResult.fold((_) {}, (list) => ids = list.toSet());

    emit(CommerceState(cartCount: count, likedIds: ids));
  }

  Future<void> loadCart() async {
    emit(
      CommerceState(
        isLoading: true,
        cart: state.cart,
        likedIds: state.likedIds,
        cartCount: state.cartCount,
      ),
    );
    final result = await _repository.getCart();
    result.fold(
      (f) => emit(CommerceState(error: f.message, likedIds: state.likedIds)),
      (cart) => emit(
        CommerceState(
          cart: cart,
          cartCount: cart.count,
          likedIds: state.likedIds,
        ),
      ),
    );
  }

  Future<void> loadWishlist() async {
    emit(
      CommerceState(
        isLoading: true,
        wishlistProducts: state.wishlistProducts,
        cartCount: state.cartCount,
        likedIds: state.likedIds,
      ),
    );
    final result = await _repository.getWishlist();
    result.fold(
      (f) => emit(CommerceState(error: f.message, cartCount: state.cartCount)),
      (products) => emit(
        CommerceState(
          wishlistProducts: products,
          cartCount: state.cartCount,
          likedIds: products.map((p) => p.id).toSet(),
        ),
      ),
    );
  }

  Future<bool> addToCart(String productId, double quantity) async {
    final result = await _repository.addToCart(productId, quantity);
    return result.fold(
      (f) {
        emit(CommerceState(error: f.message, likedIds: state.likedIds, cartCount: state.cartCount));
        return false;
      },
      (cart) {
        emit(
          CommerceState(
            cartCount: cart.count,
            likedIds: state.likedIds,
            cart: cart,
          ),
        );
        return true;
      },
    );
  }

  Future<void> updateQuantity(String cartItemId, double quantity) async {
    final result = await _repository.updateCartItem(cartItemId, quantity);
    result.fold(
      (f) => emit(CommerceState(error: f.message, likedIds: state.likedIds)),
      (cart) => emit(
        CommerceState(cart: cart, cartCount: cart.count, likedIds: state.likedIds),
      ),
    );
  }

  Future<void> removeItem(String cartItemId) async {
    final result = await _repository.removeCartItem(cartItemId);
    result.fold(
      (f) => emit(CommerceState(error: f.message, likedIds: state.likedIds)),
      (cart) => emit(
        CommerceState(cart: cart, cartCount: cart.count, likedIds: state.likedIds),
      ),
    );
  }

  Future<void> clearCart() async {
    final result = await _repository.clearCart();
    result.fold(
      (f) => emit(CommerceState(error: f.message, likedIds: state.likedIds)),
      (cart) => emit(
        CommerceState(cart: cart, cartCount: 0, likedIds: state.likedIds),
      ),
    );
  }

  Future<bool> toggleLike(String productId) async {
    final result = await _repository.toggleLike(productId);
    return result.fold(
      (f) {
        emit(CommerceState(error: f.message, cartCount: state.cartCount, likedIds: state.likedIds));
        return false;
      },
      (liked) {
        final ids = Set<String>.from(state.likedIds);
        if (liked) {
          ids.add(productId);
        } else {
          ids.remove(productId);
        }
        emit(CommerceState(cartCount: state.cartCount, likedIds: ids, cart: state.cart));
        return liked;
      },
    );
  }

  void reset() {
    emit(const CommerceState());
  }
}
