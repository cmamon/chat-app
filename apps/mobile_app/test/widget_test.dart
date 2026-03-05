import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/main.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/features/auth/domain/auth_state.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/config/app_environment.dart';

void main() {
  setUpAll(() {
    AppEnvironment.setup(
      const AppEnvironment(
        name: 'Test',
        apiBaseUrl: 'http://localhost',
        wsUrl: 'http://localhost',
        flavor: AppFlavor.development,
      ),
    );
  });

  testWidgets('Landing page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            authViewModelProvider.overrideWith(() => AuthViewModelMock()),
          ],
          child: const KoraApp(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the app title is displayed.
    expect(find.text('Kora Chat'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}

class AuthViewModelMock extends AuthViewModel {
  @override
  AuthState build() {
    return const AuthState(isAppInitializing: false);
  }
}
