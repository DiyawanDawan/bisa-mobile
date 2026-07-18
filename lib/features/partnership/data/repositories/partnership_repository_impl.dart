import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/partnership_entity.dart';
import '../../domain/repositories/partnership_repository.dart';
import '../datasources/partnership_remote_data_source.dart';
import '../models/partnership_models.dart';

class PartnershipRepositoryImpl implements PartnershipRepository {
  final PartnershipRemoteDataSource remoteDataSource;

  PartnershipRepositoryImpl({required this.remoteDataSource});

  PartnershipUserEntity _mapUser(PartnershipUserModel m) => PartnershipUserEntity(
        id: m.id,
        fullName: m.fullName,
        avatarUrl: m.avatarUrl,
        role: m.role,
        province: m.province,
        regency: m.regency,
        isVerified: m.isVerified,
        companyName: m.companyName,
        businessType: m.businessType,
      );

  PartnershipEntity _map(PartnershipModel m) => PartnershipEntity(
        id: m.id,
        contractNumber: m.contractNumber,
        buyerId: m.buyerId,
        supplierId: m.supplierId,
        tier: m.tier,
        status: m.status,
        title: m.title,
        description: m.description,
        productCategory: m.productCategory,
        estimatedMonthlyQty: m.estimatedMonthlyQty,
        priceAgreement: m.priceAgreement,
        deliveryTerms: m.deliveryTerms,
        paymentTerms: m.paymentTerms,
        specialTerms: m.specialTerms,
        startDate: m.startDate,
        endDate: m.endDate,
        buyerSignedAt: m.buyerSignedAt,
        sellerSignedAt: m.sellerSignedAt,
        platformSignedAt: m.platformSignedAt,
        buyerSignerName: m.buyerSignerName,
        buyerSignerTitle: m.buyerSignerTitle,
        buyerCompanyName: m.buyerCompanyName,
        sellerSignerName: m.sellerSignerName,
        sellerSignerTitle: m.sellerSignerTitle,
        sellerCompanyName: m.sellerCompanyName,
        platformSignerName: m.platformSignerName,
        platformSignerTitle: m.platformSignerTitle,
        isFullySigned: m.isFullySigned,
        requiredSigners: m.requiredSigners,
        signedCount: m.signedCount,
        signatures: m.signatures
            .map(
              (s) => PartnershipSignatureEntity(
                party: s.party,
                label: s.label,
                signedAt: s.signedAt,
                signerName: s.signerName,
                signerTitle: s.signerTitle,
                companyName: s.companyName,
              ),
            )
            .toList(),
        rejectionReason: m.rejectionReason,
        terminatedAt: m.terminatedAt,
        renewalCount: m.renewalCount,
        renewalProposedEndDate: m.renewalProposedEndDate,
        renewalRequestedBy: m.renewalRequestedBy,
        renewalNote: m.renewalNote,
        daysUntilExpiry: m.daysUntilExpiry,
        contractPhase: m.contractPhase,
        canRenew: m.canRenew,
        isRenewalPending: m.isRenewalPending,
        createdAt: m.createdAt,
        buyer: _mapUser(m.buyer),
        supplier: _mapUser(m.supplier),
      );

  @override
  Future<Either<Failure, PartnershipEntity>> createPartnership(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(_map(await remoteDataSource.createPartnership(body)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PartnershipEntity>>> listPartnerships({
    String? status,
  }) async {
    try {
      final list = await remoteDataSource.listPartnerships(status: status);
      return Right(list.partnerships.map(_map).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> getPartnership(String id) async {
    try {
      return Right(_map(await remoteDataSource.getPartnership(id)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity?>> checkWithSupplier(String supplierId) async {
    try {
      final check = await remoteDataSource.checkWithSupplier(supplierId);
      return Right(check.partnership != null ? _map(check.partnership!) : null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> acceptPartnership(String id) async {
    try {
      return Right(_map(await remoteDataSource.acceptPartnership(id)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> rejectPartnership(
    String id,
    String reason,
  ) async {
    try {
      return Right(_map(await remoteDataSource.rejectPartnership(id, reason)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> signPartnership(String id) async {
    try {
      return Right(_map(await remoteDataSource.signPartnership(id)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> terminatePartnership(
    String id, {
    String? reason,
  }) async {
    try {
      return Right(_map(await remoteDataSource.terminatePartnership(id, reason: reason)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> requestRenewal(
    String id,
    DateTime newEndDate, {
    String? note,
  }) async {
    try {
      return Right(
        _map(await remoteDataSource.requestRenewal(id, newEndDate, note: note)),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> acceptRenewal(String id) async {
    try {
      return Right(_map(await remoteDataSource.acceptRenewal(id)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PartnershipEntity>> rejectRenewal(
    String id, {
    String? reason,
  }) async {
    try {
      return Right(_map(await remoteDataSource.rejectRenewal(id, reason: reason)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
