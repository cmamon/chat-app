import { Controller, Get, Post, Body, Param, Inject, UseGuards, Req } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { CHAT_SERVICE } from '@app/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('chats')
export class ChatsController {
  constructor(@Inject(CHAT_SERVICE) private readonly chatClient: ClientProxy) {}

  @Get()
  async getChats(@Req() req: any) {
    return this.chatClient.send('get_user_chats', { userId: req.user.userId });
  }

  @Get(':id')
  async getChat(@Param('id') chatId: string) {
    return this.chatClient.send('get_chat', { chatId });
  }

  @Post()
  async createChat(@Body() body: { participantIds: string[]; name?: string }, @Req() req: any) {
    // Ensure the current user is part of the participants
    const participants = [...new Set([...body.participantIds, req.user.userId])];
    return this.chatClient.send('create_chat', { participantIds: participants, name: body.name });
  }

  @Get(':id/messages')
  async getMessages(@Param('id') chatId: string) {
    return this.chatClient.send('get_messages', { chatId });
  }

  @Post(':id/messages')
  async sendMessage(@Param('id') chatId: string, @Body() body: { content: string }, @Req() req: any) {
    return this.chatClient.send('save_message', {
      chatId,
      authorId: req.user.userId,
      content: body.content,
    });
  }

  @Get('ping')
  ping() {
    return this.chatClient.send('ping', { timestamp: new Date() });
  }
}
