import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/helpers.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Login pengguna
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    // Validasi domain
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(ValidationFailure(message: 'Email dan kata sandi wajib diisi'));
    }

    return _repository.login(
      params.email.trim(),
      params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
