import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/helpers.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Logout pengguna
class LogoutUseCase implements UseCaseNoParams<void> {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call() => _repository.logout();
}
