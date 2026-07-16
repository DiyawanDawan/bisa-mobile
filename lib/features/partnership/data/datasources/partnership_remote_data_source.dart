import '../models/partnership_models.dart';

abstract class PartnershipRemoteDataSource {
  Future<PartnershipModel> createPartnership(Map<String, dynamic> body);
  Future<PartnershipListModel> listPartnerships({String? status});
  Future<PartnershipModel> getPartnership(String id);
  Future<PartnershipCheckModel> checkWithSupplier(String supplierId);
  Future<PartnershipModel> acceptPartnership(String id);
  Future<PartnershipModel> rejectPartnership(String id, String reason);
  Future<PartnershipModel> signPartnership(String id);
  Future<PartnershipModel> terminatePartnership(String id, {String? reason});
  Future<PartnershipModel> requestRenewal(String id, DateTime newEndDate, {String? note});
  Future<PartnershipModel> acceptRenewal(String id);
  Future<PartnershipModel> rejectRenewal(String id, {String? reason});
}

class PartnershipRemoteDataSourceImpl implements PartnershipRemoteDataSource {
  final dynamic dio;

  PartnershipRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _data(dynamic response) =>
      response.data['data'] as Map<String, dynamic>;

  @override
  Future<PartnershipModel> createPartnership(Map<String, dynamic> body) async {
    final response = await dio.post('/partnerships', data: body);
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipListModel> listPartnerships({String? status}) async {
    final response = await dio.get(
      '/partnerships',
      queryParameters: {if (status != null) 'status': status},
    );
    return PartnershipListModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> getPartnership(String id) async {
    final response = await dio.get('/partnerships/$id');
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipCheckModel> checkWithSupplier(String supplierId) async {
    final response = await dio.get('/partnerships/check/$supplierId');
    return PartnershipCheckModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> acceptPartnership(String id) async {
    final response = await dio.put('/partnerships/$id/accept');
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> rejectPartnership(String id, String reason) async {
    final response = await dio.put('/partnerships/$id/reject', data: {'reason': reason});
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> signPartnership(String id) async {
    final response = await dio.put('/partnerships/$id/sign');
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> terminatePartnership(String id, {String? reason}) async {
    final response = await dio.put(
      '/partnerships/$id/terminate',
      data: {if (reason != null) 'reason': reason},
    );
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> requestRenewal(String id, DateTime newEndDate, {String? note}) async {
    final response = await dio.put(
      '/partnerships/$id/renew',
      data: {
        'newEndDate': newEndDate.toIso8601String(),
        if (note != null) 'note': note,
      },
    );
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> acceptRenewal(String id) async {
    final response = await dio.put('/partnerships/$id/renew/accept');
    return PartnershipModel.fromJson(_data(response));
  }

  @override
  Future<PartnershipModel> rejectRenewal(String id, {String? reason}) async {
    final response = await dio.put(
      '/partnerships/$id/renew/reject',
      data: {if (reason != null) 'reason': reason},
    );
    return PartnershipModel.fromJson(_data(response));
  }
}
