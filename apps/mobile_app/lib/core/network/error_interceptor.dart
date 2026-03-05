import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/core/exceptions/app_exception.dart';
import 'package:kora_chat/core/providers/error_provider.dart';

class ErrorInterceptor extends Interceptor {
  final Ref ref;

  ErrorInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = AppException.fromDioError(err);

    // Push error to global notifier for snackbars etc.
    // Skip canceled requests
    if (appException.type != ExceptionType.cancel) {
      ref.read(globalErrorProvider.notifier).showError(appException);
    }

    // We pass a new error with our custom type
    handler.next(err);
  }
}
