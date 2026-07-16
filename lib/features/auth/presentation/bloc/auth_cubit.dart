import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
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
        serverClientId: AppConfig.googleServerClientId,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(const AuthState.initial());
        return; // User canceled the sign-in
      }

      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(const AuthState.error('auth.google_token_failed'));
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
      emit(AuthState.error('errors.google_sign_in'));
    }
  }

  Future<void> registerBuyer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? referralCode,
  }) async {
    emit(const AuthState.loading());
    final result = await _repository.registerBuyer(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      referralCode: referralCode,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('auth.register_buyer_success')),
    );
  }

  Future<void> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
    String? referralCode,
  }) async {
    emit(const AuthState.loading());
    final result = await _repository.registerSupplier(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      province: province,
      regency: regency,
      referralCode: referralCode,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('auth.register_supplier_success')),
    );
  }

  Future<void> verifyRegistration(String email, String code) async {
    emit(const AuthState.loading());
    final result = await _repository.verifyRegistration(email, code);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('auth.verify_email_success')),
    );
  }

  Future<void> resendOtp(String email, String type) async {
    final result = await _repository.resendOtp(email, type);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('auth.otp_resent_success')),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthState.loading());
    final result = await _repository.forgotPassword(email);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('auth.reset_code_sent')),
    );
  }

  Future<void> verifyResetCode(String email, String code) async {
    emit(const AuthState.loading());
    final result = await _repository.verifyResetCode(email, code);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (token) => emit(AuthState.resetTokenReceived(token)),
    );
  }

  Future<void> resetPasswordWithToken(String token, String newPassword) async {
    emit(const AuthState.loading());
    final result = await _repository.resetPasswordWithToken(token, newPassword);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.success('auth.password_changed_success')),
    );
  }

  Future<void> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
    String? businessName,
    String? taxId,
    String? businessAddress,
  }) async {
    emit(const AuthState.loading());
    final result = await _repository.submitVerification(
      ktpPath: ktpPath,
      nibPath: nibPath,
      selfiePath: selfiePath,
      siupPath: siupPath,
      businessName: businessName,
      taxId: taxId,
      businessAddress: businessAddress,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) {
        emit(const AuthState.success('auth.verification_submitted'));
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

  /// Sinkronkan user di memori setelah update profil tanpa round-trip API.
  void applyUser(UserEntity user) {
    state.maybeWhen(
      authenticated: (_) => emit(AuthState.authenticated(user)),
      orElse: () {},
    );
  }

  Future<bool> updateEnableNotifications(bool enabled) async {
    final result = await _repository.updateEnableNotifications(enabled);
    return result.fold(
      (failure) {
        emit(AuthState.error(failure.message));
        return false;
      },
      (user) {
        emit(AuthState.authenticated(user));
        return true;
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  void sessionExpired() {
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
