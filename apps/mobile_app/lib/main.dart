import 'package:flutter/material.dart';
import 'package:kora_chat/config/app_environment.dart';
import 'package:kora_chat/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/theme/kora_theme.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/theme/kora_components.dart';
import 'package:kora_chat/core/database/database_maintenance_service.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/core/widgets/kora_error_handler.dart';
import 'package:kora_chat/config/app_router.dart';
import 'package:kora_chat/config/routes.dart';

void main() {
  bootstrap(
    const AppEnvironment(
      name: 'Development',
      apiBaseUrl: 'http://localhost:8001/chat-api',
      wsUrl: 'http://localhost:8001',
      flavor: AppFlavor.development,
    ),
  );
}

void bootstrap(AppEnvironment environment) {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setup(environment);
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const ProviderScope(child: KoraApp())));
}

class KoraApp extends ConsumerWidget {
  const KoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final router = ref.watch(routerProvider);

    // Initial Splash / Loading Screen while app initializes
    if (authState.isAppInitializing) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: KoraTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: KoraColors.primaryLight),
          ),
        ),
      );
    }

    // Start background services
    ref.watch(databaseMaintenanceServiceProvider);

    return MaterialApp.router(
      title: 'Kora Chat - ${AppEnvironment.instance.name}',
      debugShowCheckedModeBanner: AppConfig.flavor != AppFlavor.production,
      theme: KoraTheme.darkTheme,
      routerConfig: router,
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.instance.supportedLocales,
      builder: (context, child) {
        return KoraErrorHandler(child: child!);
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: KoraColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: KoraSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(KoraSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: KoraColors.primaryLight,
                  ),
                ),
                const SizedBox(height: KoraSpacing.xl),
                Text(
                  t.landing.appTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 48),
                ),
                const SizedBox(height: KoraSpacing.sm),
                Text(
                  t.landing.landingTagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: KoraColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                KoraButton(
                  text: t.landing.createAccount,
                  onTap: () => context.push(AppRoutes.register.path),
                ),
                const SizedBox(height: KoraSpacing.md),
                TextButton(
                  onPressed: () => context.push(AppRoutes.login.path),
                  child: Text(
                    t.landing.alreadyHaveAccount,
                    style: GoogleFonts.outfit(
                      color: KoraColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: KoraSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
