// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatSyncService)
final chatSyncServiceProvider = ChatSyncServiceProvider._();

final class ChatSyncServiceProvider
    extends $NotifierProvider<ChatSyncService, void> {
  ChatSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSyncServiceHash();

  @$internal
  @override
  ChatSyncService create() => ChatSyncService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$chatSyncServiceHash() => r'9e9de25148ba2644142cf5eae8303d387e8f2cb1';

abstract class _$ChatSyncService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
