import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Inject } from '@nestjs/common';
import { Server, Socket } from 'socket.io';
import { Logger } from '@app/logger';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { CHAT_SERVICE } from '@app/common';
import { ClientProxy } from '@nestjs/microservices';
import { firstValueFrom } from 'rxjs';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(
    private readonly logger: Logger,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    @Inject(CHAT_SERVICE) private readonly chatClient: ClientProxy,
  ) {}

  async handleConnection(@ConnectedSocket() client: Socket) {
    try {
      const token = client.handshake.auth.token;
      if (!token) {
        this.logger.warn('Connection attempt without token');
        client.disconnect();
        return;
      }

      const payload = this.jwtService.verify(token, {
        secret: this.configService.get<string>('JWT_SECRET') || 'defaultSecret',
      });

      // Attach user info to socket
      client.data.userId = payload.sub || payload.userId;
      client.data.username = payload.username;
      client.data.email = payload.email;

      this.logger.log(`Client connected: ${client.data.email} (${client.id})`);
    } catch (error) {
      this.logger.error(`Connection verification failed: ${error.message}`);
      client.disconnect();
    }
  }

  handleDisconnect(@ConnectedSocket() client: Socket) {
    this.logger.log(`Client disconnected: ${client.data.email || 'unknown'} (${client.id})`);

    if (client.data.roomId && client.data.username) {
      this.server.to(client.data.roomId).emit('user_left', {
        userId: client.data.userId,
        username: client.data.username,
      });
      this.logger.log(`User ${client.data.username} left room: ${client.data.roomId}`);
    }
  }

  @SubscribeMessage('join_room')
  async handleJoinRoom(@ConnectedSocket() client: Socket, @MessageBody() payload: { roomId: string }) {
    const { roomId } = payload;
    await client.join(roomId);
    client.data.roomId = roomId; // Track current room

    this.logger.log(`User ${client.data.username} joined room: ${roomId}`);

    // Notify others in the room
    this.server.to(roomId).emit('user_joined', {
      userId: client.data.userId,
      username: client.data.username,
    });

    return { success: true, roomId };
  }

  @SubscribeMessage('send_message')
  async handleMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { roomId: string; content: string; clientMsgId?: string },
  ) {
    const { roomId, content, clientMsgId } = payload;

    try {
      // 1. Save message to database via chat-service
      const savedMessage = await firstValueFrom(
        this.chatClient.send('save_message', {
          chatId: roomId,
          authorId: client.data.userId,
          content,
        }),
      );

      // 2. Broadcast the saved message to everyone in the room (including sender)
      this.server.to(roomId).emit('new_message', {
        ...savedMessage,
        roomId, // Ensure roomId is present for frontend filtering
        clientMsgId, // Return the clientMsgId if provided
      });

      this.logger.log(`Message in ${roomId} from ${client.data.username} saved and broadcasted`);
      return { success: true, messageId: savedMessage.id, clientMsgId };
    } catch (error) {
      this.logger.error(`Failed to save message: ${error.message}`);
      return { success: false, error: 'Could not save message' };
    }
  }
}
