import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  /// Factory constructor to parse Dio errors into human-readable messages
  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ApiException(message: 'Request to API server was cancelled');

      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'Connection timeout with API server');

      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout in connection with API server',
        );

      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout in connection with API server',
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No Internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        return ApiException._handleBadResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Bad certificate error. Connection is not secure.',
        );

      case DioExceptionType.unknown:
        return ApiException(message: 'An unexpected network error occurred.');
    }
  }

  /// Helper to handle specific HTTP Status Codes
  factory ApiException._handleBadResponse(int? statusCode, dynamic data) {
    String? serverMessage;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('errors') &&
          data['errors'] is List &&
          (data['errors'] as List).isNotEmpty) {

        serverMessage = data['errors'][0]['message']?.toString();
      }
      else if (data.containsKey('message')) {
        serverMessage = data['message']?.toString();
      }
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: serverMessage ?? 'Bad request. Please check your inputs.',
          statusCode: statusCode,
        );
      case 401:
        return ApiException(
          message: serverMessage ?? 'Unauthorized. Please login again.',
          statusCode: statusCode,
        );
      case 403:
        return ApiException(
          message:
          serverMessage ??
              'You do not have permission to access this resource.',
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: serverMessage ?? 'The requested resource was not found.',
          statusCode: statusCode,
        );
      case 422:
        return ApiException(
          message:
          serverMessage ?? 'Validation error. Please check your inputs.',
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return ApiException(
          message: 'Internal server error. Please try again later.',
          statusCode: statusCode,
        );
      default:
        return ApiException(
          message: serverMessage ?? 'Oops something went wrong',
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() => message;
}
