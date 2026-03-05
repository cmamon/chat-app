// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socketService)
final socketServiceProvider = SocketServiceProvider._();

final class SocketServiceProvider
    extends $FunctionalProvider<SocketService, SocketService, SocketService>
    with $Provider<SocketService> {
  SocketServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketServiceHash();

  @$internal
  @override
  $ProviderElement<SocketService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocketService create(Ref ref) {
    return socketService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocketService>(value),
    );
  }
}

String _$socketServiceHash() => r'54090fb9bfdacfdf7f597c085033db90f54f7fa3';
