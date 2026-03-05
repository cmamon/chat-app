import 'package:kora_chat/config/app_environment.dart';
import 'package:kora_chat/main.dart';

void main() {
  bootstrap(
    const AppEnvironment(
      name: 'Staging',
      apiBaseUrl:
          'https://api.staging.kora-chat.com/chat-api', // Generic placeholder, user can update
      wsUrl: 'https://api.staging.kora-chat.com',
      flavor: AppFlavor.staging,
    ),
  );
}
