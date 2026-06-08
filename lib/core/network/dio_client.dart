import 'package:dio/dio.dart';
import '../../data/datasource/local/auth_local_data_source.dart';

class DioClient {
  final AuthLocalDataSource _localDataSource;

  DioClient(this._localDataSource);

  Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.100.69:5000/api/",
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // skip auth APIs
          if (!options.path.contains("login") &&
              !options.path.contains("signup") &&
              !options.path.contains("send-otp") &&
              !options.path.contains("verify-otp") &&
              !options.path.contains("onboarding") &&
              !options.path.contains("forgot-password") &&
              !options.path.contains("reset-password") &&
              !options.path.contains("google-login") &&
              !options.path.contains("facebook-login")) {
            final token = _localDataSource.getToken();

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}
