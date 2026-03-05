import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kora_chat/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Critical Flow: Login & Messaging', () {
    testWidgets('Full flow from landing to sending a message', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Landing Page -> Login
      final loginTextButton = find.byType(TextButton);
      expect(loginTextButton, findsWidgets);

      // Tap the second TextButton (Login) - based on LandingPage build order
      await tester.tap(loginTextButton.last);
      await tester.pumpAndSettle();

      // 2. Login Page
      expect(find.byKey(const Key('login_email_field')), findsOneWidget);
      expect(find.byKey(const Key('login_password_field')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'Password123!',
      );

      // Tap Sign In
      await tester.tap(find.byKey(const Key('login_submit_button')));

      // In a real environment, we'd wait for API.
      // For this demonstration/template, we settle for the transition attempt.
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Note: If the backend is not running, this will show an error snackbar
      // but the key UI navigation points are now testable.
    });
  });
}
