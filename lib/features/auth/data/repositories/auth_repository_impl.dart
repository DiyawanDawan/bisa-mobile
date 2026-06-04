import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/token_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../../../profile/data/models/address_model.dart';
import '../../../profile/domain/entities/address_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenRepository tokenRepository;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenRepository,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final data = await remoteDataSource.login(email, password);
      final userModel = UserModel.fromJson(data['user']);
      final tokens = data['token'];

      await tokenRepository.saveTokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
      );

      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle(String idToken) async {
    try {
      final data = await remoteDataSource.loginWithGoogle(idToken);
      final userModel = UserModel.fromJson(data['user']);
      final tokens = data['token'];

      await tokenRepository.saveTokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken'],
      );

      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getMe();
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? avatarPath,
  }) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        fullName: fullName,
        phone: phone,
        companyName: companyName,
        avatarPath: avatarPath,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (_) {
      try {
        final refreshed = await remoteDataSource.getMe();
        return Right(refreshed.toEntity());
      } catch (e) {
        if (e is DioException) {
          return Left(_mapDioExceptionToFailure(e));
        }
        return const Left(UnexpectedFailure());
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateEnableNotifications(bool enabled) async {
    try {
      final userModel = await remoteDataSource.updateEnableNotifications(enabled);
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenRepository.clearTokens();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerBuyer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final userModel = await remoteDataSource.registerBuyer(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
  }) async {
    try {
      final userModel = await remoteDataSource.registerSupplier(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        province: province,
        regency: regency,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyRegistration(
    String email,
    String code,
  ) async {
    try {
      await remoteDataSource.verifyRegistration(email, code);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email, String type) async {
    try {
      await remoteDataSource.resendOtp(email, type);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyResetCode(
    String email,
    String code,
  ) async {
    try {
      await remoteDataSource.verifyResetCode(email, code);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordWithToken(
    String token,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.resetPasswordWithToken(token, newPassword);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String password) async {
    try {
      await remoteDataSource.changePassword(password);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
  }) async {
    try {
      await remoteDataSource.submitVerification(
        ktpPath: ktpPath,
        nibPath: nibPath,
        selfiePath: selfiePath,
        siupPath: siupPath,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final list = await remoteDataSource.getAddresses();
      return Right(
        list.map((e) => AddressModel.fromJson(e).toEntity()).toList(),
      );
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> createAddress(
    Map<String, dynamic> data,
  ) async {
    try {
      final json = await remoteDataSource.createAddress(data);
      if (json.isEmpty) {
        return const Left(
          ServerFailure(message: 'Respons server alamat kosong'),
        );
      }
      return Right(AddressModel.fromJson(json).toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memproses data alamat: $e'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final json = await remoteDataSource.updateAddress(id, data);
      if (json.isEmpty) {
        return const Left(
          ServerFailure(message: 'Respons server alamat kosong'),
        );
      }
      return Right(AddressModel.fromJson(json).toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memproses data alamat: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    try {
      await remoteDataSource.deleteAddress(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String id) async {
    try {
      await remoteDataSource.setDefaultAddress(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getPublicProfile(String id) async {
    try {
      final userModel = await remoteDataSource.getPublicProfile(id);
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDioExceptionToFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const TimeoutFailure();
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final rawData = e.response?.data;
      final data = rawData is Map<String, dynamic> ? rawData : null;
      final message =
          data?['meta']?['message'] ?? data?['message'] ?? 'Terjadi kesalahan';

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          return const NotFoundFailure();
        case 422:
          return ValidationFailure(
            message: message,
            errors: _extractErrors(data),
          );
        default:
          return ServerFailure(message: message, statusCode: statusCode);
      }
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }

  Map<String, List<String>>? _extractErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] is Map) {
      return (data['errors'] as Map).map(
        (k, v) => MapEntry(
          k.toString(),
          (v as List).map((e) => e.toString()).toList(),
        ),
      );
    }
    return null;
  }
}
