import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/config/app_config.dart';
import 'package:kora_chat/features/auth/data/auth_repository.dart';
import 'package:kora_chat/features/chat/data/chat_repository.dart';
import 'package:kora_chat/services/token_service.dart';
import 'package:kora_chat/core/network/logging_interceptor.dart';
import 'package:kora_chat/core/network/error_interceptor.dart';

part 'api_providers.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Custom Interceptors
  dio.interceptors.add(LoggingInterceptor(ref));
  dio.interceptors.add(ErrorInterceptor(ref));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final ts = ref.read(tokenServiceProvider);
        final token = await ts.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await ref.read(tokenServiceProvider).deleteToken();
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final d = ref.watch(dioProvider);
  return AuthRepository(d);
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  final d = ref.watch(dioProvider);
  return ChatRepository(d);
}
