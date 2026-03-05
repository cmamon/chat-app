// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatViewModel)
final chatViewModelProvider = ChatViewModelProvider._();

final class ChatViewModelProvider
    extends $NotifierProvider<ChatViewModel, ChatState> {
  ChatViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatViewModelHash();

  @$internal
  @override
  ChatViewModel create() => ChatViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }
}

String _$chatViewModelHash() => r'b20603181f801bfe8450a84fa4e6769fa532ca47';

abstract class _$ChatViewModel extends $Notifier<ChatState> {
  ChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredChats)
final filteredChatsProvider = FilteredChatsProvider._();

final class FilteredChatsProvider
    extends
        $FunctionalProvider<
          List<domain.Chat>,
          List<domain.Chat>,
          List<domain.Chat>
        >
    with $Provider<List<domain.Chat>> {
  FilteredChatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredChatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredChatsHash();

  @$internal
  @override
  $ProviderElement<List<domain.Chat>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<domain.Chat> create(Ref ref) {
    return filteredChats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<domain.Chat> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<domain.Chat>>(value),
    );
  }
}

String _$filteredChatsHash() => r'f363d830fe4551c3ccf56f50e52c1073d6cfde27';
