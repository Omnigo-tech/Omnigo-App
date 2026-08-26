import 'package:dio/dio.dart';
import '../../data/datasource/local/auth_local_data_source.dart';

class DioClient {
  final AuthLocalDataSource _localDataSource;

  DioClient(this._localDataSource);

  Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl:
        'https://omnigo-app-backend-production.up.railway.app/api/',

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        // Timeouts
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // =====================================================
          // SKIP AUTH APIs
          // =====================================================

          if (!options.path.contains('login') &&
              !options.path.contains('signup') &&
              !options.path.contains('send-otp') &&
              !options.path.contains('verify-otp') &&
              !options.path.contains('onboarding') &&
              !options.path.contains('forgot-password') &&
              !options.path.contains('reset-password') &&
              !options.path.contains('google-login') &&
              !options.path.contains('facebook-login')) {

            final token = _localDataSource.getToken();

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          // =====================================================
          // DEBUG REQUEST
          // =====================================================

          print('================ DIO REQUEST ================');
          print('METHOD: ${options.method}');
          print('URL: ${options.uri}');
          print('PATH: ${options.path}');
          print('QUERY: ${options.queryParameters}');
          print('HEADERS: ${options.headers}');
          print('==============================================');

          return handler.next(options);
        },

        // =====================================================
        // RESPONSE
        // =====================================================

        onResponse: (response, handler) {
          print('================ DIO RESPONSE ================');
          print('STATUS: ${response.statusCode}');
          print('URL: ${response.requestOptions.uri}');
          print('DATA: ${response.data}');
          print('===============================================');

          return handler.next(response);
        },

        // =====================================================
        // ERROR
        // =====================================================

        onError: (DioException error, handler) {
          print('================ DIO ERROR ===================');
          print('TYPE: ${error.type}');
          print('MESSAGE: ${error.message}');
          print('ERROR: ${error.error}');
          print('URL: ${error.requestOptions.uri}');
          print('STATUS: ${error.response?.statusCode}');
          print('RESPONSE: ${error.response?.data}');
          print('===============================================');

          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}