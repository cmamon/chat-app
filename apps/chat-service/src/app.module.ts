import { Module } from '@nestjs/common';
import { PrismaModule } from '@app/database';
import { ChatController } from './chat.controller';
import { ChatsService } from './chats/chats.service';
import { ChatsController } from './chats/chats.controller';

@Module({
  imports: [PrismaModule],
  controllers: [ChatController, ChatsController],
  providers: [ChatsService],
})
export class AppModule {}
