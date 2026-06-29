import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/utils/payment_status_utils.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';

part 'order_state.dart';
part 'order_cubit.freezed.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;

  OrderCubit(this._repository) : super(const OrderState.initial());

  static const _pageSize = 20;
  int _listPage = 1;
  bool _hasMoreOrders = true;
  bool _loadingMore = false;

  bool get hasMoreOrders => _hasMoreOrders;
  bool get isLoadingMore => _loadingMore;

  Future<void> getMyPurchases({
    String? search,
    String? status,
    String? orderType,
  }) async {
    emit(const OrderState.loading());
    _listPage = 1;
    final q = search?.trim();
    final result = await _repository.getMyPurchases(
      page: 1,
      limit: _pageSize,
      search: q != null && q.isNotEmpty ? q : null,
      status: status != null && status != 'ALL' && status != 'REFUNDED'
          ? status
          : null,
      orderType: orderType != null && orderType != 'ALL' ? orderType : null,
    );
    result.fold(
      (failure) => emit(OrderState.error(failure.message)),
      (orders) {
        _hasMoreOrders = orders.length >= _pageSize;
        emit(OrderState.loaded(orders));
      },
    );
  }

  Future<void> getMySales({
    String? search,
    String? status,
    String? orderType,
  }) async {
    emit(const OrderState.loading());
    _listPage = 1;
    final q = search?.trim();
    final result = await _repository.getMySales(
      page: 1,
      limit: _pageSize,
      search: q != null && q.isNotEmpty ? q : null,
      status: status != null && status != 'ALL' && status != 'REFUNDED'
          ? status
          : null,
      orderType: orderType != null && orderType != 'ALL' ? orderType : null,
    );
    result.fold(
      (failure) => emit(OrderState.error(failure.message)),
      (orders) {
        _hasMoreOrders = orders.length >= _pageSize;
        emit(OrderState.loaded(orders));
      },
    );
  }

  Future<void> loadMoreOrders({
    String? search,
    String? status,
    String? orderType,
    required bool isSupplier,
  }) async {
    if (!_hasMoreOrders || _loadingMore) return;
    final current = state.maybeWhen(loaded: (orders) => orders, orElse: () => null);
    if (current == null) return;

    _loadingMore = true;
    _listPage += 1;
    final q = search?.trim();
    final apiStatus = status != null && status != 'ALL' && status != 'REFUNDED' ? status : null;
    final apiOrderType =
        orderType != null && orderType != 'ALL' ? orderType : null;
    final apiSearch = q != null && q.isNotEmpty ? q : null;

    final result = isSupplier
        ? await _repository.getMySales(
            page: _listPage,
            limit: _pageSize,
            search: apiSearch,
            status: apiStatus,
            orderType: apiOrderType,
          )
        : await _repository.getMyPurchases(
            page: _listPage,
            limit: _pageSize,
            search: apiSearch,
            status: apiStatus,
            orderType: apiOrderType,
          );

    _loadingMore = false;
    result.fold(
      (failure) {
        _listPage -= 1;
        emit(OrderState.error(failure.message));
      },
      (orders) {
        _hasMoreOrders = orders.length >= _pageSize;
        emit(OrderState.loaded([...current, ...orders]));
      },
    );
  }

  /// Poll sampai backend mengonfirmasi pembayaran sukses.
  Future<bool> pollPaymentStatus(String orderId) {
    return pollOrderPaymentStatus(_repository, orderId);
  }

  Future<OrderEntity?> getOrderDetail(String id, {bool silent = false}) async {
    if (!silent) {
      emit(const OrderState.loading());
    }
    final result = await _repository.getOrderDetail(id);
    return result.fold(
      (failure) {
        if (!silent) {
          emit(OrderState.error(failure.message));
        }
        return null;
      },
      (order) {
        emit(OrderState.loaded([order]));
        return order;
      },
    );
  }

  /// Returns payment payload on success, `null` on failure (also emits error state).
  Future<Map<String, dynamic>?> initializePayment(
    String orderId,
    String channelCode, {
    bool forceNew = false,
  }) async {
    final previousOrders = state.maybeWhen(
      loaded: (orders) => orders,
      orElse: () => null,
    );

    emit(const OrderState.loading());
    final result = await _repository.initializePayment(
      orderId,
      channelCode,
      forceNew: forceNew,
    );

    return result.fold(
      (failure) {
        emit(OrderState.error(failure.message));
        return null;
      },
      (data) {
        if (previousOrders != null) {
          emit(OrderState.loaded(previousOrders));
        } else {
          emit(OrderState.paymentSuccess(data));
        }
        return data;
      },
    );
  }

  /// Satu pembayaran gabungan untuk semua pesanan checkout cart.
  Future<Map<String, dynamic>?> initializeBatchPayment(
    List<String> orderIds,
    String channelCode, {
    bool forceNew = false,
  }) async {
    final previousOrders = state.maybeWhen(
      loaded: (orders) => orders,
      orElse: () => null,
    );

    emit(const OrderState.loading());
    final result = await _repository.initializeBatchPayment(
      orderIds,
      channelCode,
      forceNew: forceNew,
    );

    return result.fold(
      (failure) {
        emit(OrderState.error(failure.message));
        return null;
      },
      (data) {
        if (previousOrders != null) {
          emit(OrderState.loaded(previousOrders));
        } else {
          emit(OrderState.paymentSuccess(data));
        }
        return data;
      },
    );
  }

  Future<Map<String, dynamic>?> getSalesStats() async {
    final result = await _repository.getSalesStats();
    return result.fold(
      (failure) => throw failure,
      (stats) => stats,
    );
  }

  Future<Map<String, int>> fetchOrderStatusCounts({
    required bool isSupplier,
    String? search,
    String? orderType,
  }) async {
    final q = search?.trim();
    final apiSearch = q != null && q.isNotEmpty ? q : null;
    final apiOrderType =
        orderType != null && orderType != 'ALL' ? orderType : null;

    final result = isSupplier
        ? await _repository.getMySalesStatusCounts(
            search: apiSearch,
            orderType: apiOrderType,
          )
        : await _repository.getMyPurchasesStatusCounts(
            search: apiSearch,
            orderType: apiOrderType,
          );

    return result.fold((_) => const {}, (counts) => counts);
  }

  Future<void> releaseEscrow(String id) async {
    emit(const OrderState.loading());
    final result = await _repository.releaseEscrow(id);
    result.fold(
      (failure) => emit(OrderState.error(failure.message)),
      (_) => getOrderDetail(id),
    );
  }

  Future<void> raiseDispute(
    String id,
    String reason,
    String description,
    List<String> evidenceImagePaths,
  ) async {
    emit(const OrderState.loading());
    final result = await _repository.raiseDispute(
      id,
      reason,
      description,
      evidenceImagePaths,
    );
    result.fold(
      (failure) => emit(OrderState.error(failure.message)),
      (_) => getOrderDetail(id),
    );
  }

  Future<void> respondToDispute(
    String id,
    String response,
    List<String> evidenceImagePaths,
  ) async {
    emit(const OrderState.loading());
    final result = await _repository.respondToDispute(
      id,
      response,
      evidenceImagePaths,
    );
    result.fold(
      (failure) => emit(OrderState.error(failure.message)),
      (_) => getOrderDetail(id),
    );
  }

  Future<void> updateTracking(String id, Map<String, dynamic> data) async {
    emit(const OrderState.loading());
    final result = await _repository.updateTracking(id, data);
    result.fold(
      (failure) => emit(OrderState.error(failure.message)),
      (_) => getOrderDetail(id),
    );
  }

  /// Direct checkout dari cart. Tidak emit state karena UI cart yang akan
  /// menampilkan dialog/snackbar berdasarkan hasil.
  ///
  /// Return `DirectOrderResult.success(orders)` jika berhasil, atau
  /// `DirectOrderResult.failure(message)` jika gagal.
  Future<DirectOrderResult> createDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? orderType,
    String? voucherCode,
  }) async {
    final result = await _repository.createDirectOrder(
      items: items,
      shippingAddress: shippingAddress,
      shippingSnapshot: shippingSnapshot,
      shippingSelections: shippingSelections,
      notes: notes,
      orderType: orderType,
      voucherCode: voucherCode,
    );
    return result.fold(
      (failure) {
        if (failure is ReadinessFailure) {
          return DirectOrderResult.failure(
            failure.message,
            code: failure.code,
          );
        }
        return DirectOrderResult.failure(failure.message);
      },
      (data) {
        final orders = (data['orders'] as List?) ?? const [];
        final parsed = orders
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        return DirectOrderResult.success(parsed);
      },
    );
  }

  Future<Map<String, dynamic>?> previewDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? voucherCode,
  }) async {
    final result = await _repository.previewDirectOrder(
      items: items,
      shippingAddress: shippingAddress,
      shippingSnapshot: shippingSnapshot,
      shippingSelections: shippingSelections,
      notes: notes,
      voucherCode: voucherCode,
    );
    return result.fold((_) => null, (data) => data);
  }

  Future<Map<String, dynamic>?> validateVoucher({
    required String code,
    required double subtotal,
    List<String>? sellerIds,
  }) async {
    final result = await _repository.validateVoucher(
      code: code,
      subtotal: subtotal,
      sellerIds: sellerIds,
    );
    return result.fold((_) => null, (data) => data);
  }

  Future<Map<String, dynamic>?> getShippingOrigin() async {
    final result = await _repository.getShippingOrigin();
    return result.fold((_) => null, (data) => data);
  }

  Future<bool> setShippingOrigin({
    required int originId,
    String? originLabel,
  }) async {
    final result = await _repository.setShippingOrigin(
      originId: originId,
      originLabel: originLabel,
    );
    return result.isRight();
  }

  Future<ShippingDestinationSearchResult> searchShippingDestinations({
    required String search,
    int limit = 20,
    int offset = 0,
  }) async {
    final result = await _repository.searchShippingDestinations(
      search: search,
      limit: limit,
      offset: offset,
    );
    return result.fold(
      (failure) => ShippingDestinationSearchResult.failure(failure.message),
      (data) => ShippingDestinationSearchResult.success(data),
    );
  }

  Future<List<Map<String, dynamic>>> calculateDomesticShipping({
    required int originId,
    required int destinationId,
    required int weightGrams,
    String? courier,
  }) async {
    final result = await _repository.calculateDomesticShipping(
      originId: originId,
      destinationId: destinationId,
      weightGrams: weightGrams,
      courier: courier,
    );
    return result.fold((_) => const [], (data) => data);
  }

  Future<Map<String, dynamic>?> syncTrackingFromRajaOngkir({
    required String orderId,
    required String awb,
    required String courier,
    String? lastPhoneNumber,
  }) async {
    final result = await _repository.trackShipment(
      awb: awb,
      courier: courier,
      lastPhoneNumber: lastPhoneNumber,
      orderId: orderId,
    );
    return result.fold((_) => null, (data) => data);
  }

  Future<List<Map<String, dynamic>>> getPickupVehicles() async {
    final result = await _repository.getPickupVehicles();
    return result.fold((_) => const [], (data) => data);
  }

  Future<List<String>> getActiveCouriers() async {
    final result = await _repository.getActiveCouriers();
    return result.fold((_) => const [], (data) => data);
  }

  Future<List<Map<String, dynamic>>> requestPickup({
    required String pickupDate,
    required String pickupTime,
    required String pickupVehicle,
    required List<String> orderNumbers,
  }) async {
    final result = await _repository.requestPickup(
      pickupDate: pickupDate,
      pickupTime: pickupTime,
      pickupVehicle: pickupVehicle,
      orderNumbers: orderNumbers,
    );
    return result.fold((_) => const [], (data) => data);
  }
}

class ShippingDestinationSearchResult {
  final List<Map<String, dynamic>> items;
  final String? errorMessage;

  const ShippingDestinationSearchResult._({
    required this.items,
    this.errorMessage,
  });

  factory ShippingDestinationSearchResult.success(
    List<Map<String, dynamic>> items,
  ) =>
      ShippingDestinationSearchResult._(items: items);

  factory ShippingDestinationSearchResult.failure(String message) =>
      ShippingDestinationSearchResult._(items: const [], errorMessage: message);

  bool get quotaExceeded {
    final msg = errorMessage?.toLowerCase() ?? '';
    return msg.contains('kuota') ||
        msg.contains('daily limit') ||
        msg.contains('shipping quota') ||
        msg.contains('cart.api_quota_exhausted');
  }
}

class DirectOrderResult {
  final bool isSuccess;
  final List<Map<String, dynamic>> orders;
  final String? errorMessage;
  final String? errorCode;

  const DirectOrderResult._({
    required this.isSuccess,
    this.orders = const [],
    this.errorMessage,
    this.errorCode,
  });

  factory DirectOrderResult.success(List<Map<String, dynamic>> orders) =>
      DirectOrderResult._(isSuccess: true, orders: orders);

  factory DirectOrderResult.failure(
    String message, {
    String? code,
  }) =>
      DirectOrderResult._(
        isSuccess: false,
        errorMessage: message,
        errorCode: code,
      );

  bool get isBuyerReadiness =>
      errorCode == 'BUYER_NOT_READY' ||
      (errorMessage != null && isBuyerReadinessMessage(errorMessage!));
}
