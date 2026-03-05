enum AppFlavor { development, staging, production }

class AppEnvironment {
  final String name;
  final String apiBaseUrl;
  final String wsUrl;
  final AppFlavor flavor;

  const AppEnvironment({
    required this.name,
    required this.apiBaseUrl,
    required this.wsUrl,
    required this.flavor,
  });

  static late AppEnvironment _instance;
  static AppEnvironment get instance => _instance;

  static void setup(AppEnvironment environment) {
    _instance = environment;
  }
}
