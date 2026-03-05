import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/auth/data/auth_repository.dart';
import 'package:kora_chat/services/token_service.dart';
import 'package:kora_chat/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/features/auth/domain/auth_models.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTokenService extends Mock implements TokenService {}

void main() {
  late MockAuthRepository mockRepository;
  late MockTokenService mockTokenService;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockTokenService = MockTokenService();

    // Default mock behavior to prevent crashes during auto-initialization in build()
    when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
        tokenServiceProvider.overrideWithValue(mockTokenService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> waitForInitialization(ProviderContainer container) async {
    await Future.delayed(Duration.zero); // allow build() microtasks to start
    // Wait for the initialization microtask and subsequent async calls
    int attempts = 0;
    while (container.read(authViewModelProvider).isAppInitializing &&
        attempts < 100) {
      await Future.delayed(const Duration(milliseconds: 10));
      attempts++;
    }
  }

  group('AuthViewModel Units', () {
    test(
      'Initial initialization without token should set unauthenticated',
      () async {
        when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);

        final container = makeContainer();
        await waitForInitialization(container);

        final state = container.read(authViewModelProvider);
        expect(state.isAppInitializing, false);
        expect(state.isAuthenticated, false);
      },
    );

    test(
      'Initial initialization with valid token should set authenticated',
      () async {
        const user = UserProfile(
          id: '1',
          email: 'test@test.com',
          username: 'tester',
        );
        when(() => mockTokenService.hasToken()).thenAnswer((_) async => true);
        when(() => mockRepository.getProfile()).thenAnswer((_) async => user);

        final container = makeContainer();
        await waitForInitialization(container);

        final state = container.read(authViewModelProvider);
        expect(state.isAuthenticated, true);
        expect(state.currentUser, user);
        expect(state.isAppInitializing, false);
      },
    );

    test('Initial initialization with invalid token should logout', () async {
      when(() => mockTokenService.hasToken()).thenAnswer((_) async => true);
      when(
        () => mockRepository.getProfile(),
      ).thenThrow(Exception('Unauthorized'));
      when(() => mockTokenService.deleteToken()).thenAnswer((_) async => {});

      final container = makeContainer();
      await waitForInitialization(container);

      final state = container.read(authViewModelProvider);
      expect(state.isAuthenticated, false);
      expect(state.isAppInitializing, false);
      verify(() => mockTokenService.deleteToken()).called(1);
    });
    group('Input Changes', () {
      test('onEmailChanged should update state', () {
        final container = makeContainer();
        container
            .read(authViewModelProvider.notifier)
            .onEmailChanged('test@test.com');
        expect(container.read(authViewModelProvider).email, 'test@test.com');
      });
    });
  });
}
