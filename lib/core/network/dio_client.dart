import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'token_storage.dart';

/// Configures a single Dio instance used across the whole app.
/// The interceptor automatically attaches "Authorization: Bearer <token>"
/// to every request if a token is stored, so individual datasources
/// never have to think about auth headers.
class DioClient {
  final Dio dio;
  final TokenStorage tokenStorage;

  DioClient(this.tokenStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}
