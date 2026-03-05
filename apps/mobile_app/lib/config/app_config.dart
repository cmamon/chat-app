import 'package:kora_chat/config/app_environment.dart';

class AppConfig {
  static String get apiBaseUrl => AppEnvironment.instance.apiBaseUrl;
  static String get wsUrl => AppEnvironment.instance.wsUrl;
  static AppFlavor get flavor => AppEnvironment.instance.flavor;
}
