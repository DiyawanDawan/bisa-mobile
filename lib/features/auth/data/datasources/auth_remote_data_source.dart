import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> loginWithGoogle(String idToken);
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
  });
  Future<UserModel> registerSupplier({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? province,
    String? regency,
  });
  Future<void> verifyRegistration(String email, String code);
  Future<void> resendOtp(String email, String type);
  Future<void> forgotPassword(String email);
  Future<void> verifyResetCode(String email, String code);
  Future<void> resetPasswordWithToken(String token, String newPassword);
  Future<void> changePassword(String password);
  Future<void> submitVerification({
    String? ktpPath,
    String? nibPath,
    String? selfiePath,
    String? siupPath,
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

  AuthRemoteDataSourceImpl({required this.dio});

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
      'idToken': idToken,
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
  }) async {
    final response = await dio.post('/auth/register/buyer', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
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
  }) async {
    final response = await dio.post('/auth/register/supplier', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'province': province,
      'regency': regency,
    });
    return UserModel.fromJson(response.data['data']);
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
    await dio.post('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<void> verifyResetCode(String email, String code) async {
    await dio.post('/auth/verify-reset-code', data: {
      'email': email,
      'code': code,
    });
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
  }) async {
    final formData = FormData();
    
    if (ktpPath != null) {
      formData.files.add(MapEntry('ktp', await MultipartFile.fromFile(ktpPath, filename: ktpPath.split('/').last)));
    }
    if (nibPath != null) {
      formData.files.add(MapEntry('nib', await MultipartFile.fromFile(nibPath, filename: nibPath.split('/').last)));
    }
    if (selfiePath != null) {
      formData.files.add(MapEntry('selfie', await MultipartFile.fromFile(selfiePath, filename: selfiePath.split('/').last)));
    }
    if (siupPath != null) {
      formData.files.add(MapEntry('siup', await MultipartFile.fromFile(siupPath, filename: siupPath.split('/').last)));
    }

    await dio.post('/users/me/verify', data: formData);
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
