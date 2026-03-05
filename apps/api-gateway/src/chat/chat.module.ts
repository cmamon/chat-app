import { Module } from '@nestjs/common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { CHAT_SERVICE } from '@app/common';
import { ChatsController } from './chats.controller';

@Module({
  imports: [
    ClientsModule.registerAsync([
      {
        name: CHAT_SERVICE,
        imports: [ConfigModule],
        inject: [ConfigService],
        useFactory: (configService: ConfigService) => ({
          transport: Transport.NATS,
          options: {
            servers: [configService.get('NATS_URL', 'nats://localhost:4222')],
          },
        }),
      },
    ]),
  ],
  controllers: [ChatsController],
  exports: [ClientsModule],
})
export class ChatModule {}
