// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessageViewModel)
final messageViewModelProvider = MessageViewModelFamily._();

final class MessageViewModelProvider
    extends $NotifierProvider<MessageViewModel, MessageState> {
  MessageViewModelProvider._({
    required MessageViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'messageViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageViewModelHash();

  @override
  String toString() {
    return r'messageViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MessageViewModel create() => MessageViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MessageViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageViewModelHash() => r'344ab26d9e726ba52da786b75308202a4a50ad33';

final class MessageViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          MessageViewModel,
          MessageState,
          MessageState,
          MessageState,
          String
        > {
  MessageViewModelFamily._()
    : super(
        retry: null,
        name: r'messageViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MessageViewModelProvider call(String chatId) =>
      MessageViewModelProvider._(argument: chatId, from: this);

  @override
  String toString() => r'messageViewModelProvider';
}

abstract class _$MessageViewModel extends $Notifier<MessageState> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  MessageState build(String chatId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MessageState, MessageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MessageState, MessageState>,
              MessageState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
