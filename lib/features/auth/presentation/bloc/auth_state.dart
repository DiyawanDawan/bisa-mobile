part of 'auth_cubit.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.success(String message) = _Success;
  const factory AuthState.resetTokenReceived(String token) = _ResetTokenReceived;
  const factory AuthState.error(String message) = _Error;
}
