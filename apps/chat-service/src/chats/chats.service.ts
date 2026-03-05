import { Injectable } from '@nestjs/common';
import { PrismaService } from '@app/database';

@Injectable()
export class ChatsService {
  constructor(private readonly prisma: PrismaService) {}

  async getUserChats(userId: string) {
    const chats = await this.prisma.chat.findMany({
      where: {
        participants: {
          some: {
            id: userId,
          },
        },
      },
      include: {
        participants: {
          select: {
            id: true,
            username: true,
            email: true,
            avatarUrl: true,
          },
        },
        messages: {
          take: 1,
          orderBy: {
            createdAt: 'desc',
          },
        },
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });

    return chats.map((chat) => {
      const lastMessage = chat.messages[0];
      return {
        id: chat.id,
        name: chat.name,
        participants: chat.participants,
        lastMessage: lastMessage
          ? {
              id: lastMessage.id,
              content: lastMessage.content,
              chatId: lastMessage.chatId,
              senderId: lastMessage.authorId,
              createdAt: lastMessage.createdAt,
            }
          : null,
        isGroup: chat.participants.length > 2 || !!chat.name,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
      };
    });
  }

  async createChat(participantIds: string[], name?: string) {
    // If it's a direct chat (2 participants) and no name is provided,
    // check if it already exists.
    if (participantIds.length === 2 && !name) {
      const existingChat = await this.prisma.chat.findFirst({
        where: {
          AND: [
            { participants: { some: { id: participantIds[0] } } },
            { participants: { some: { id: participantIds[1] } } },
            { participants: { none: { id: { notIn: participantIds } } } },
          ],
        },
        include: {
          participants: true,
        },
      });

      if (existingChat) {
        return existingChat;
      }
    }

    const chat = await this.prisma.chat.create({
      data: {
        name,
        participants: {
          connect: participantIds.map((id) => ({ id })),
        },
      },
      include: {
        participants: {
          select: {
            id: true,
            username: true,
            email: true,
            avatarUrl: true,
          },
        },
      },
    });

    return {
      id: chat.id,
      name: chat.name,
      participants: chat.participants,
      lastMessage: null,
      isGroup: participantIds.length > 2 || !!name,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
    };
  }

  async saveMessage(chatId: string, authorId: string, content: string) {
    const message = await this.prisma.message.create({
      data: {
        content,
        author: {
          connect: { id: authorId },
        },
        chat: {
          connect: { id: chatId },
        },
      },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            email: true,
            avatarUrl: true,
          },
        },
      },
    });

    return {
      id: message.id,
      chatId: message.chatId,
      senderId: message.authorId,
      content: message.content,
      createdAt: message.createdAt,
      author: message.author,
    };
  }

  async getMessages(chatId: string) {
    const messages = await this.prisma.message.findMany({
      where: { chatId },
      include: {
        author: {
          select: {
            id: true,
            username: true,
            email: true,
            avatarUrl: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });

    return messages.map((message) => ({
      id: message.id,
      chatId: message.chatId,
      senderId: message.authorId,
      content: message.content,
      createdAt: message.createdAt,
      author: message.author,
    }));
  }

  async getChat(chatId: string) {
    const chat = await this.prisma.chat.findUnique({
      where: { id: chatId },
      include: {
        participants: {
          select: {
            id: true,
            username: true,
            email: true,
            avatarUrl: true,
          },
        },
        messages: {
          take: 1,
          orderBy: {
            createdAt: 'desc',
          },
        },
      },
    });

    if (!chat) return null;

    const lastMessage = chat.messages[0];
    return {
      id: chat.id,
      name: chat.name,
      participants: chat.participants,
      lastMessage: lastMessage
        ? {
            id: lastMessage.id,
            content: lastMessage.content,
            chatId: lastMessage.chatId,
            senderId: lastMessage.authorId,
            createdAt: lastMessage.createdAt,
          }
        : null,
      isGroup: chat.participants.length > 2 || !!chat.name,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
    };
  }
}
