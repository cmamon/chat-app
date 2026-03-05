import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kora_chat/features/chat/presentation/viewmodels/message_viewmodel.dart';
import 'package:kora_chat/features/chat/data/chat_repository.dart';
import 'package:kora_chat/services/socket_service.dart';
import 'package:kora_chat/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/features/chat/domain/chat_models.dart';
import 'package:kora_chat/features/chat/domain/message_state.dart';

import 'package:drift/native.dart';
import 'package:kora_chat/core/database/app_database.dart';

import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/auth/domain/auth_state.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockSocketService extends Mock implements SocketService {}

/// Fake AuthViewModel to avoid Riverpod's internal element issues and SecureStorage dependencies.
class FakeAuthViewModel extends AuthViewModel {
  final AuthState _initialState;
  FakeAuthViewModel(this._initialState);

  @override
  AuthState build() => _initialState;

  @override
  Future<void> checkInitialAuth() async {
    // No-op for testing to avoid FlutterSecureStorage
  }
}

void main() {
  late MockChatRepository mockRepository;
  late MockSocketService mockSocketService;
  late AppDatabase db;
  const tChatId = 'chat_123';
  const tUserId = 'user_123';

  final tAuthState = AuthState(
    currentUser: const UserProfile(
      id: tUserId,
      username: 'test',
      email: 'test@test.com',
    ),
    isAuthenticated: true,
    isAppInitializing: false,
  );

  setUp(() {
    mockRepository = MockChatRepository();
    mockSocketService = MockSocketService();
    db = AppDatabase(NativeDatabase.memory());

    // Default mock behavior
    when(() => mockSocketService.connect()).thenReturn(null);
    when(() => mockSocketService.joinRoom(any())).thenReturn(null);

    // Register fallback for clientMsgId since it's a named parameter
    registerFallbackValue(tChatId);

    when(
      () => mockSocketService.sendMessage(
        any(),
        any(),
        clientMsgId: any(named: 'clientMsgId'),
      ),
    ).thenReturn(null);

    when(
      () => mockSocketService.messageStream,
    ).thenAnswer((_) => const Stream.empty());
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        chatRepositoryProvider.overrideWithValue(mockRepository),
        socketServiceProvider.overrideWithValue(mockSocketService),
        authViewModelProvider.overrideWith(() => FakeAuthViewModel(tAuthState)),
      ],
    );
    addTearDown(() async {
      await db.close();
      container.dispose();
    });
    return container;
  }

  group('MessageViewModel Units', () {
    test('Initial loading fetches chat and messages', () async {
      const chat = Chat(id: tChatId, participants: []);
      final messages = [
        Message(
          id: '1',
          chatId: tChatId,
          senderId: 'u1',
          content: 'Hi',
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockRepository.getChat(tChatId)).thenAnswer((_) async => chat);
      when(
        () => mockRepository.getMessages(tChatId),
      ).thenAnswer((_) async => messages);

      final container = makeContainer();
      final states = <MessageState>[];

      // Listen to capture all state transitions
      container.listen<MessageState>(messageViewModelProvider(tChatId), (
        previous,
        next,
      ) {
        states.add(next);
      }, fireImmediately: true);

      // Wait for async operations to complete
      int attempts = 0;
      while (states.every((s) => s.currentChat == null) && attempts < 100) {
        await Future.delayed(const Duration(milliseconds: 50));
        attempts++;
      }

      expect(states.any((s) => s.currentChat?.id == tChatId), isTrue);
      final lastState = states.last;
      expect(lastState.messages.length, messages.length);
      expect(lastState.messages.first.content, 'Hi');
    });

    test('sendMessage calls socket service with optimistic ID', () async {
      when(
        () => mockRepository.getChat(any()),
      ).thenAnswer((_) async => const Chat(id: tChatId, participants: []));
      when(() => mockRepository.getMessages(any())).thenAnswer((_) async => []);

      final container = makeContainer();

      // Wait for initialization to avoid late state updates during sendMessage
      await Future.delayed(const Duration(milliseconds: 50));

      final viewModel = container.read(
        messageViewModelProvider(tChatId).notifier,
      );
      await viewModel.sendMessage('Hello');

      verify(
        () => mockSocketService.sendMessage(
          tChatId,
          'Hello',
          clientMsgId: any(named: 'clientMsgId', that: startsWith('opt_')),
        ),
      ).called(1);
    });
  });
}
