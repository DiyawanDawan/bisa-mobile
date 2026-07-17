part of 'support_cubit.dart';

@freezed
class SupportState with _$SupportState {
  const factory SupportState.initial() = _Initial;
  const factory SupportState.loading() = _Loading;
  const factory SupportState.loaded(
    SupportTicket ticket, {
    @Default(false) bool isSending,
    String? notice,
    String? actionError,
  }) = _Loaded;
  const factory SupportState.error(String message) = _Error;
}
