import 'package:kora_chat/core/exceptions/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_provider.g.dart';

@riverpod
class GlobalErrorNotifier extends _$GlobalErrorNotifier {
  @override
  AppException? build() => null;

  void showError(AppException exception) {
    state = exception;
  }

  void clearError() {
    state = null;
  }
}
