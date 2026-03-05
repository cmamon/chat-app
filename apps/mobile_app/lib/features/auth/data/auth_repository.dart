import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../domain/auth_models.dart';

part 'auth_repository.g.dart';

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @GET('/auth/me')
  Future<UserProfile> getProfile();

  @POST('/users/avatar')
  @MultiPart()
  Future<AvatarUploadResponse> uploadAvatar(
    @Part(name: 'file') MultipartFile file,
  );

  @GET('/users/search')
  Future<List<UserProfile>> searchUsers(@Query('q') String query);
}
