import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/core/utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Ref ref;

  LoggingInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.i('==> ${options.method} ${options.uri}');
    if (options.data != null) {
      Log.d('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.i(
      '<== ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    if (response.data != null) {
      Log.d('Response: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e(
      'ERR: ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}',
      err.error,
    );
    super.onError(err, handler);
  }
}
