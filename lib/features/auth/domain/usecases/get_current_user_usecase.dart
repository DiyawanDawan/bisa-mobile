import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/helpers.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Ambil data user yang sedang login
class GetCurrentUserUseCase implements UseCaseNoParams<UserEntity> {
  final AuthRepository _repository;
  const GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call() => _repository.getCurrentUser();
}
