import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/address_entity.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit(this._authRepository) : super(const ProfileState.initial());

  Future<void> getProfile() async {
    emit(const ProfileState.loading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? avatarPath,
  }) async {
    emit(const ProfileState.loading());
    final result = await _authRepository.updateProfile(
      fullName: fullName,
      phone: phone,
      companyName: companyName,
      avatarPath: avatarPath,
    );
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (user) => emit(ProfileState.success('profil_berhasil_diperbarui')),
    );
  }

  Future<void> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
  }) async {
    emit(const ProfileState.loading());
    final result = await _authRepository.submitVerification(
      ktpPath: ktpPath,
      nibPath: nibPath,
      selfiePath: selfiePath,
      siupPath: siupPath,
    );
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) => getProfile(),
    );
  }

  Future<void> _reloadAddresses() async {
    final result = await _authRepository.getAddresses();
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (addresses) => emit(ProfileState.addressesLoaded(addresses)),
    );
  }

  Future<void> getAddresses() async {
    emit(const ProfileState.loading());
    await _reloadAddresses();
  }

  /// Simpan alamat tanpa emit [ProfileState.loading] agar bottom sheet tidak
  /// “hilang” dan daftar alamat tetap terlihat saat request berjalan.
  Future<bool> addAddress(Map<String, dynamic> data) async {
    final wantsPrimary = data['isPrimary'] == true;
    final payload = Map<String, dynamic>.from(data)..remove('isPrimary');

    final result = await _authRepository.createAddress(payload);
    return await result.fold(
      (failure) async {
        emit(ProfileState.error(failure.message));
        return false;
      },
      (created) async {
        if (wantsPrimary) {
          final primaryResult =
              await _authRepository.setDefaultAddress(created.id);
          return primaryResult.fold(
            (failure) {
              emit(ProfileState.error(failure.message));
              return false;
            },
            (_) async {
              await _reloadAddresses();
              return true;
            },
          );
        }
        await _reloadAddresses();
        return true;
      },
    );
  }

  Future<bool> updateAddress(String id, Map<String, dynamic> data) async {
    final wantsPrimary = data['isPrimary'] == true;
    final payload = Map<String, dynamic>.from(data)..remove('isPrimary');

    final result = await _authRepository.updateAddress(id, payload);
    return await result.fold(
      (failure) async {
        emit(ProfileState.error(failure.message));
        return false;
      },
      (_) async {
        if (wantsPrimary) {
          final primaryResult = await _authRepository.setDefaultAddress(id);
          return primaryResult.fold(
            (failure) {
              emit(ProfileState.error(failure.message));
              return false;
            },
            (_) async {
              await _reloadAddresses();
              return true;
            },
          );
        }
        await _reloadAddresses();
        return true;
      },
    );
  }

  Future<void> setDefaultAddress(String id) async {
    final result = await _authRepository.setDefaultAddress(id);
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) => _reloadAddresses(),
    );
  }

  Future<void> deleteAddress(String id) async {
    final result = await _authRepository.deleteAddress(id);
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) => _reloadAddresses(),
    );
  }
}
