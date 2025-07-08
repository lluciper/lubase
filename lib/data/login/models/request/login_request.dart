import 'package:json_annotation/json_annotation.dart';

part 'generated/login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String userName;
  final String password;

  LoginRequest({
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
