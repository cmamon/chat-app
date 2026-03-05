import 'package:kora_chat/config/app_environment.dart';
import 'package:kora_chat/main.dart';

void main() {
  bootstrap(
    const AppEnvironment(
      name: 'Production',
      apiBaseUrl:
          'https://api.kora-chat.com/chat-api', // Generic placeholder, user can update
      wsUrl: 'https://api.kora-chat.com',
      flavor: AppFlavor.production,
    ),
  );
}
