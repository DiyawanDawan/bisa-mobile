import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';
import '../../../profile/domain/entities/address_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _repository.login(email, password);
    await result.fold(
      (failure) async => emit(AuthState.error(failure.message)),
      (_) async {
        final refreshed = await _repository.getCurrentUser();
        refreshed.fold(
          (failure) => emit(AuthState.error(failure.message)),
          (user) => emit(AuthState.authenticated(user)),
        );
      },
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(const AuthState.loading());
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: '94564351976-o1k5d6sd9pna74e7angarlr8qrvln2pv.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        emit(const AuthState.initial());
        return; // User canceled the sign-in
      }

      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(const AuthState.error('Gagal mendapatkan token dari Google.'));
        return;
      }

      final result = await _repository.loginWithGoogle(idToken);
      result.fold(
        (failure) {
          googleSignIn.signOut();
          emit(AuthState.error(failure.message));
        },
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (e) {
      emit(AuthState.error('Terjadi kesalahan saat masuk dengan Google: ${e.toString()}'));
    }
  }

  Future<void> registerBuyer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    emit(const AuthState.loading());
    final result = await _repository.registerBuyer(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(
        const AuthState.success(
          'Buyer berhasil terdaftar. Silakan cek OTP Anda.',
        ),
      ),
    );
  }

  Future<void> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
  }) async {
    emit(const AuthState.loading());
    final result = await _repository.registerSupplier(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      province: province,
      regency: regency,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(
        const AuthState.success(
          'Supplier berhasil terdaftar. Silakan cek OTP Anda.',
        ),
      ),
    );
  }

  Future<void> verifyRegistration(String email, String code) async {
    emit(const AuthState.loading());
    final result = await _repository.verifyRegistration(email, code);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('Email berhasil diverifikasi. Silakan login.')),
    );
  }

  Future<void> resendOtp(String email, String type) async {
    final result = await _repository.resendOtp(email, type);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('Kode OTP baru telah dikirim')),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthState.loading());
    final result = await _repository.forgotPassword(email);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('Kode reset telah dikirim ke email Anda')),
    );
  }

  Future<void> verifyResetCode(String email, String code) async {
    emit(const AuthState.loading());
    final result = await _repository.verifyResetCode(email, code);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (data) {
        final token = (data as Map)['resetToken']?.toString() ?? '';
        emit(AuthState.resetTokenReceived(token));
      },
    );
  }

  Future<void> resetPasswordWithToken(String token, String newPassword) async {
    emit(const AuthState.loading());
    final result = await _repository.resetPasswordWithToken(token, newPassword);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('Kata sandi berhasil diubah. Silakan masuk kembali.')),
    );
  }

  Future<void> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
  }) async {
    emit(const AuthState.loading());
    final result = await _repository.submitVerification(
      ktpPath: ktpPath,
      nibPath: nibPath,
      selfiePath: selfiePath,
      siupPath: siupPath,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) {
        emit(const AuthState.success('Dokumen verifikasi berhasil dikirim. Mohon tunggu tim kami meninjau akun Anda.'));
        checkAuth(); // Refresh user data to see verification status
      },
    );
  }

  Future<void> checkAuth() async {
    final result = await _repository.getCurrentUser();
    await result.fold(
      (_) async {
        await _repository.logout();
        emit(const AuthState.unauthenticated());
      },
      (user) async => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  Future<List<AddressEntity>> getAddresses() async {
    final result = await _repository.getAddresses();
    return result.fold(
      (failure) => [],
      (addresses) => addresses,
    );
  }
}
