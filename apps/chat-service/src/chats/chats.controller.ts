import { Controller } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';
import { ChatsService } from './chats.service';

@Controller()
export class ChatsController {
  constructor(private readonly chatsService: ChatsService) {}

  @MessagePattern('get_user_chats')
  async getUserChats(@Payload() data: { userId: string }) {
    return this.chatsService.getUserChats(data.userId);
  }

  @MessagePattern('create_chat')
  async createChat(@Payload() data: { participantIds: string[]; name?: string }) {
    return this.chatsService.createChat(data.participantIds, data.name);
  }

  @MessagePattern('save_message')
  async saveMessage(@Payload() data: { chatId: string; authorId: string; content: string }) {
    return this.chatsService.saveMessage(data.chatId, data.authorId, data.content);
  }

  @MessagePattern('get_messages')
  async getMessages(@Payload() data: { chatId: string }) {
    return this.chatsService.getMessages(data.chatId);
  }

  @MessagePattern('get_chat')
  async getChat(@Payload() data: { chatId: string }) {
    return this.chatsService.getChat(data.chatId);
  }
}
