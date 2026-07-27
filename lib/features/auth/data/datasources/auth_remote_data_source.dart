import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> loginWithGoogle(String idToken);
  Future<Map<String, dynamic>> loginWithFacebook(String idToken);
  Future<UserModel> getMe();
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? avatarPath,
  });
  Future<UserModel> updateEnableNotifications(bool enabled);
  Future<UserModel> registerBuyer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? referralCode,
  });
  Future<UserModel> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
    String? referralCode,
  });
  Future<bool> checkEmailAvailable(String email);
  Future<void> verifyRegistration(String email, String code);
  Future<void> resendOtp(String email, String type);
  Future<void> forgotPassword(String email);
  Future<String> verifyResetCode(String email, String code);
  Future<void> resetPasswordWithToken(String token, String newPassword);
  Future<void> changePassword(String password);
  Future<void> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
    String? businessName,
    String? taxId,
    String? businessAddress,
    void Function(String status)? onUploadStatus,
  });
  Future<List<Map<String, dynamic>>> getAddresses();
  Future<Map<String, dynamic>> createAddress(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateAddress(String id, Map<String, dynamic> data);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
  Future<UserModel> getPublicProfile(String id);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final MediaUploadQueue uploadQueue;

  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.uploadQueue,
  });

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await dio.post('/auth/google', data: {
      'token': idToken,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> loginWithFacebook(String idToken) async {
    final response = await dio.post('/auth/facebook', data: {
      'token': idToken,
    });
    return response.data['data'];
  }

  @override
  Future<UserModel> getMe() async {
    final response = await dio.get('/users/me');
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? avatarPath,
  }) async {
    final formData = FormData.fromMap({
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (companyName != null) 'companyName': companyName,
      if (avatarPath != null)
        'avatar': await MultipartFile.fromFile(
          avatarPath,
          filename: avatarPath.split('/').last,
        ),
    });

    final response = await dio.patch(
      '/users/me',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> updateEnableNotifications(bool enabled) async {
    final response = await dio.patch(
      '/users/me',
      data: {'enableNotifications': enabled},
      options: Options(contentType: 'application/json'),
    );
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> registerBuyer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? referralCode,
  }) async {
    final response = await dio.post('/auth/register/buyer', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      if (referralCode != null && referralCode.isNotEmpty) 'referralCode': referralCode,
    });
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
    String? referralCode,
  }) async {
    final response = await dio.post('/auth/register/supplier', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'province': province,
      'regency': regency,
      if (referralCode != null && referralCode.isNotEmpty) 'referralCode': referralCode,
    });
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> checkEmailAvailable(String email) async {
    final response = await dio.get(
      '/auth/check-email',
      queryParameters: {'email': email},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return data['available'] == true;
  }

  @override
  Future<void> verifyRegistration(String email, String code) async {
    await dio.post('/auth/verify-registration', data: {
      'email': email,
      'code': code,
    });
  }

  @override
  Future<void> resendOtp(String email, String type) async {
    await dio.post('/auth/resend-otp', data: {
      'email': email,
      'type': type,
    });
  }

  @override
  Future<void> forgotPassword(String email) async {
    await dio.post('/auth/resend-otp', data: {
      'email': email,
      'type': 'RESET_PASSWORD',
    });
  }

  @override
  Future<String> verifyResetCode(String email, String code) async {
    final response = await dio.post('/auth/verify-reset-code', data: {
      'email': email,
      'code': code,
    });
    final data = response.data['data'];
    if (data is Map && data['resetToken'] != null) {
      return data['resetToken'].toString();
    }
    throw const FormatException('resetToken tidak ditemukan dalam response');
  }

  @override
  Future<void> resetPasswordWithToken(String token, String newPassword) async {
    await dio.post('/auth/reset-password/$token', data: {
      'password': newPassword,
    });
  }

  @override
  Future<void> changePassword(String password) async {
    await dio.post('/auth/reset-password', data: {'password': password});
  }

  @override
  Future<void> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
    String? businessName,
    String? taxId,
    String? businessAddress,
    void Function(String status)? onUploadStatus,
  }) async {
    final body = <String, dynamic>{};
    var hasDocument = false;

    Future<void> addDoc(String? localPath, String field, String statusCode) async {
      if (localPath == null) return;
      onUploadStatus?.call(statusCode);
      final uploaded = await uploadQueue.uploadFile(
        localPath: localPath,
        folder: 'verification',
        forceFresh: true,
      );
      body[field] = uploaded.path;
      hasDocument = true;
    }

    await addDoc(ktpPath, 'ktpUrl', 'ktp');
    await addDoc(nibPath, 'nibUrl', 'nib');
    await addDoc(selfiePath, 'selfieUrl', 'selfie');
    await addDoc(siupPath, 'siupUrl', 'siup');

    if (businessName != null && businessName.trim().isNotEmpty) {
      body['businessName'] = businessName.trim();
    }
    if (taxId != null && taxId.trim().isNotEmpty) {
      body['taxId'] = taxId.trim();
    }
    if (businessAddress != null && businessAddress.trim().isNotEmpty) {
      body['businessAddress'] = businessAddress.trim();
    }

    if (!hasDocument) {
      throw Exception('Missing required verification documents');
    }

    onUploadStatus?.call('submit');
    await dio.post(
      '/users/me/verify',
      data: body,
      options: Options(contentType: 'application/json'),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAddresses() async {
    final response = await dio.get('/users/me/addresses');
    final List data = response.data['data'];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> createAddress(Map<String, dynamic> data) async {
    final response = await dio.post('/users/me/addresses', data: data);
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> updateAddress(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/users/me/addresses/$id', data: data);
    return response.data['data'];
  }

  @override
  Future<void> deleteAddress(String id) async {
    await dio.delete('/users/me/addresses/$id');
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    await dio.patch('/users/me/addresses/$id/set-default');
  }

  @override
  Future<UserModel> getPublicProfile(String id) async {
    final response = await dio.get('/users/$id');
    return UserModel.fromJson(response.data['data']);
  }
}
