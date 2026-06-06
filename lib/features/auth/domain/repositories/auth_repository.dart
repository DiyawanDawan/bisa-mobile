import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../../../profile/domain/entities/address_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> loginWithGoogle(String idToken);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? avatarPath,
  });
  Future<Either<Failure, UserEntity>> updateEnableNotifications(bool enabled);
  Future<Either<Failure, UserEntity>> registerBuyer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });
  Future<Either<Failure, UserEntity>> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
  });
  Future<Either<Failure, void>> verifyRegistration(String email, String code);
  Future<Either<Failure, void>> resendOtp(String email, String type);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, String>> verifyResetCode(String email, String code);
  Future<Either<Failure, void>> resetPasswordWithToken(
    String token,
    String newPassword,
  );
  Future<Either<Failure, void>> changePassword(String password);
  Future<Either<Failure, void>> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
  });
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
  Future<Either<Failure, AddressEntity>> createAddress(Map<String, dynamic> data);
  Future<Either<Failure, AddressEntity>> updateAddress(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteAddress(String id);
  Future<Either<Failure, void>> setDefaultAddress(String id);
  Future<Either<Failure, UserEntity>> getPublicProfile(String id);
}
