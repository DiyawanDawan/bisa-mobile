import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_bisa/firebase_options.dart';
import '../../../../core/config/app_config.dart';
import '../../domain/entities/user_entity.dart';
import '../../../profile/domain/entities/address_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState.initial());

  Future<void> _ensureFirebaseReady() async {
    if (Firebase.apps.isNotEmpty) return;
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  Future<void> _signOutSocialProviders() async {
    try {
      await GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: AppConfig.googleServerClientId,
      ).signOut();
    } catch (_) {}
    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (_) {}
  }

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

  /// Google Sign-In → Firebase Auth → kirim Firebase ID token ke backend.
  /// Backend memverifikasi dengan Firebase Admin (`verifyIdToken`).
  Future<void> loginWithGoogle() async {
    try {
      emit(const AuthState.loading());
      await _ensureFirebaseReady();

      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: AppConfig.googleServerClientId,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(const AuthState.initial());
        return; // User canceled the sign-in
      }

      final googleAuth = await googleUser.authentication;
      final googleIdToken = googleAuth.idToken;
      if (googleIdToken == null || googleIdToken.isEmpty) {
        await googleSignIn.signOut();
        emit(const AuthState.error('auth.google_token_failed'));
        return;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleIdToken,
        accessToken: googleAuth.accessToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseIdToken = await userCredential.user?.getIdToken(true);

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        await _signOutSocialProviders();
        emit(const AuthState.error('auth.google_token_failed'));
        return;
      }

      final result = await _repository.loginWithGoogle(firebaseIdToken);
      await result.fold(
        (failure) async {
          await _signOutSocialProviders();
          emit(AuthState.error(failure.message));
        },
        (user) async => emit(AuthState.authenticated(user)),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('[Auth] Google FirebaseAuthException: ${e.code} ${e.message}');
      }
      await _signOutSocialProviders();
      emit(AuthState.error(e.message ?? 'errors.google_sign_in'));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Auth] Google sign-in failed: $e\n$st');
      }
      await _signOutSocialProviders();
      emit(const AuthState.error('errors.google_sign_in'));
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
    await _signOutSocialProviders();
    emit(const AuthState.unauthenticated());
  }

  void sessionExpired() {
    unawaited(_signOutSocialProviders());
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
