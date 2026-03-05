import 'package:dio/dio.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';

enum ExceptionType {
  network,
  unauthorized,
  server,
  badRequest,
  unknown,
  cancel,
  timeout,
}

class AppException implements Exception {
  final String? message;
  final ExceptionType type;
  final int? statusCode;

  AppException({this.message, required this.type, this.statusCode});

  String getLocalizedMessage(Translations t) {
    if (message != null && message!.isNotEmpty) return message!;

    switch (type) {
      case ExceptionType.network:
        return t.error.errorNetwork;
      case ExceptionType.unauthorized:
        return t.error.errorUnauthorized;
      case ExceptionType.server:
        return t.error.errorServer;
      case ExceptionType.timeout:
        return t.error.errorTimeout;
      case ExceptionType.badRequest:
        return t.error.errorBadRequest;
      default:
        return t.error.errorUnknown;
    }
  }

  factory AppException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(type: ExceptionType.timeout);

      case DioExceptionType.connectionError:
        return AppException(type: ExceptionType.network);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message']?.toString();

        if (statusCode == 401) {
          return AppException(
            type: ExceptionType.unauthorized,
            statusCode: statusCode,
            message: message,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return AppException(
            type: ExceptionType.server,
            statusCode: statusCode,
          );
        } else if (statusCode == 400 || statusCode == 422) {
          return AppException(
            type: ExceptionType.badRequest,
            statusCode: statusCode,
            message: message,
          );
        }
        return AppException(
          type: ExceptionType.unknown,
          statusCode: statusCode,
          message: message,
        );

      case DioExceptionType.cancel:
        return AppException(type: ExceptionType.cancel);

      default:
        return AppException(
          type: ExceptionType.unknown,
          message: error.message,
        );
    }
  }

  @override
  String toString() =>
      'AppException(type: $type, statusCode: $statusCode, message: $message)';
}
