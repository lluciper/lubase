import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../endpoint.dart';
import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

// Project imports:

part 'generated/login_api.g.dart';

@RestApi()
abstract class LoginApi {
  factory LoginApi(Dio dio, {String baseUrl}) = _LoginApi;

  @POST(AuthEndpoint.login)
  Future<LoginResponse> login(@Body() LoginRequest request);
}
