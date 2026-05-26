import 'package:dio/dio.dart';

import 'exceptions.dart';

class ErrorHandler {

  static Exception handle(DioException error) {

    if (error.response != null) {

      final data = error.response?.data;

      switch (error.response?.statusCode) {

        case 400:
          return ServerException(
            data["message"] ?? "Bad request",
          );

        case 401:
          return ServerException(
            data["message"] ?? "Unauthorized",
          );

        case 404:
          return ServerException(
            data["message"] ?? "API not found",
          );

        case 409:
          return ServerException(
            data["message"] ?? "Conflict occurred",
          );

        case 422:
          return ServerException(
            data["message"] ?? "Validation failed",
          );

        case 500:
          return ServerException(
            data["message"] ?? "Internal server error",
          );

        default:
          return ServerException(
            data["message"] ??
                "Something went wrong",
          );
      }
    }

    else {

      switch (error.type) {

        case DioExceptionType.connectionTimeout:
          return NetworkException("Connection timeout");

        case DioExceptionType.receiveTimeout:
          return NetworkException("Receive timeout");

        case DioExceptionType.sendTimeout:
          return NetworkException("Send timeout");

        case DioExceptionType.connectionError:
          return NetworkException("No internet connection");

        default:
          return NetworkException("Unexpected network error");
      }
    }
  }
}