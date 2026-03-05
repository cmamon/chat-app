import 'package:kora_chat/config/app_environment.dart';
import 'package:kora_chat/main.dart';

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
