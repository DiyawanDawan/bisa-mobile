part of 'order_cubit.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.loaded(List<OrderEntity> orders) = _Loaded;
  const factory OrderState.paymentSuccess(Map<String, dynamic> data) = _PaymentSuccess;
  const factory OrderState.error(String message) = _Error;
}
