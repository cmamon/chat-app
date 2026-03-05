import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../domain/chat_models.dart';

part 'chat_repository.g.dart';

@RestApi()
abstract class ChatRepository {
  factory ChatRepository(Dio dio, {String baseUrl}) = _ChatRepository;

  @GET('/chats')
  Future<List<Chat>> getChats();

  @GET('/chats/{id}')
  Future<Chat> getChat(@Path('id') String id);

  @GET('/chats/{id}/messages')
  Future<List<Message>> getMessages(
    @Path('id') String id, {
    @Query('limit') int limit = 50,
    @Query('offset') int offset = 0,
  });

  @POST('/chats/{id}/messages')
  Future<Message> sendMessage(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/chats')
  Future<Chat> createChat(@Body() Map<String, dynamic> body);
}
