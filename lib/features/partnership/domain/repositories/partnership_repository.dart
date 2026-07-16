import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/partnership_entity.dart';

abstract class PartnershipRepository {
  Future<Either<Failure, PartnershipEntity>> createPartnership(Map<String, dynamic> body);
  Future<Either<Failure, List<PartnershipEntity>>> listPartnerships({String? status});
  Future<Either<Failure, PartnershipEntity>> getPartnership(String id);
  Future<Either<Failure, PartnershipEntity?>> checkWithSupplier(String supplierId);
  Future<Either<Failure, PartnershipEntity>> acceptPartnership(String id);
  Future<Either<Failure, PartnershipEntity>> rejectPartnership(String id, String reason);
  Future<Either<Failure, PartnershipEntity>> signPartnership(String id);
  Future<Either<Failure, PartnershipEntity>> terminatePartnership(String id, {String? reason});
  Future<Either<Failure, PartnershipEntity>> requestRenewal(
    String id,
    DateTime newEndDate, {
    String? note,
  });
  Future<Either<Failure, PartnershipEntity>> acceptRenewal(String id);
  Future<Either<Failure, PartnershipEntity>> rejectRenewal(String id, {String? reason});
}
