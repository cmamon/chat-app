// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalErrorNotifier)
final globalErrorProvider = GlobalErrorNotifierProvider._();

final class GlobalErrorNotifierProvider
    extends $NotifierProvider<GlobalErrorNotifier, AppException?> {
  GlobalErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalErrorNotifierHash();

  @$internal
  @override
  GlobalErrorNotifier create() => GlobalErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppException? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppException?>(value),
    );
  }
}

String _$globalErrorNotifierHash() =>
    r'0d2e791f4e4f4cd8e44452d43c8c19d2208d650c';

abstract class _$GlobalErrorNotifier extends $Notifier<AppException?> {
  AppException? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppException?, AppException?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppException?, AppException?>,
              AppException?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
