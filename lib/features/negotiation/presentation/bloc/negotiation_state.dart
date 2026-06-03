part of 'negotiation_cubit.dart';

@freezed
class NegotiationState with _$NegotiationState {
  const factory NegotiationState.initial() = _Initial;
  const factory NegotiationState.loading() = _Loading;
  const factory NegotiationState.loaded(List<NegotiationEntity> negotiations) = _Loaded;
  const factory NegotiationState.detailLoaded(
    NegotiationEntity negotiation, {
    @Default(false) bool isTyping,
    @Default(false) bool isLoadingOlderMessages,
  }) = _DetailLoaded;
  const factory NegotiationState.error(String message) = _Error;
  const factory NegotiationState.success(String message) = _Success;
}
