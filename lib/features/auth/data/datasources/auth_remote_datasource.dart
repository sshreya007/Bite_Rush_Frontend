import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Talks directly to the Express API for auth endpoints.
/// Throws ServerException/NetworkException on failure — the repository
/// catches these and converts them to Failures for the domain layer.
abstract class AuthRemoteDataSource {
  Future<(String token, UserModel user)> login({
    required String email,
    required String password,
  });

  Future<(String token, UserModel user)> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  const AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<(String, UserModel)> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'] as String;
      final user = UserModel.fromJson(response.data['user']);
      return (token, user);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<(String, UserModel)> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {'name': name, 'phone': phone, 'email': email, 'password': password},
      );
      final token = response.data['token'] as String;
      final user = UserModel.fromJson(response.data['user']);
      return (token, user);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw ServerException(_extractMessage(e));
    }
  }

  /// Pulls the backend's { message: "..." } out of the error response,
  /// falling back to a generic message for network-level failures
  /// (timeout, no connection, etc.) where there's no response body.
  String _extractMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Could not connect to server. Check your internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}
