part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(UserEntity user) = _Loaded;
  const factory ProfileState.addressesLoaded(List<AddressEntity> addresses) = _AddressesLoaded;
  const factory ProfileState.success(String message) = _Success;
  const factory ProfileState.error(String message) = _Error;
}
