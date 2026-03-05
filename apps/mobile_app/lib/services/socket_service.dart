import 'dart:async';
import 'package:kora_chat/config/app_config.dart';
import 'package:kora_chat/services/token_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/core/utils/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'socket_service.g.dart';

@Riverpod(keepAlive: true)
SocketService socketService(Ref ref) {
  return SocketService(ref);
}

class SocketService {
  final Ref _ref;
  io.Socket? _socket;
  StreamController<Map<String, dynamic>>? _messageController;

  SocketService(this._ref);

  Stream<Map<String, dynamic>> get messageStream {
    _messageController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _messageController!.stream;
  }

  bool get isConnected => _socket?.connected ?? false;

  void connect() async {
    if (_socket?.connected == true) return;

    final token = await _ref.read(tokenServiceProvider).getToken();
    if (token == null) return;

    _socket = io.io(AppConfig.wsUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    _socket!.onConnect((_) {
      _ref.read(appLoggerProvider).i('WebSocket: Connected');
    });

    _socket!.onDisconnect((_) {
      _ref.read(appLoggerProvider).w('WebSocket: Disconnected');
    });

    _socket!.on('new_message', (data) {
      if (_messageController != null && !_messageController!.isClosed) {
        _messageController!.add(data);
      }
    });

    _socket!.on('error', (data) {
      _ref.read(appLoggerProvider).e('WebSocket: Error', error: data);
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _messageController?.close();
    _messageController = null;
  }

  void joinRoom(String roomId) {
    if (_socket?.connected == true) {
      _socket!.emit('join_room', {'roomId': roomId});
    }
  }

  void sendMessage(String roomId, String content, {String? clientMsgId}) {
    if (_socket?.connected == true) {
      _socket!.emit('send_message', {
        'roomId': roomId,
        'content': content,
        'clientMsgId': clientMsgId,
      });
    }
  }
}
