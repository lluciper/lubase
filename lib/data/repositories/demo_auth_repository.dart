import '../models/auth/login_request_model.dart';
import '../models/auth/login_response_model.dart';
import 'auth_repository.dart';

/// Development only (wired in `Dependence`): logs in without a backend so the
/// app flow — login guard, deep links, logout — can be tried before the dev API
/// has a login endpoint. Any email/password that passes the form validation
/// works; tokens are stored and cleared like real ones.
// shortcut: the fake tokens are rejected by any real API (a 401 → refresh →
// rejected → logout); delete this class once the dev API can log in.
class DemoAuthRepository extends AuthRepository {
  DemoAuthRepository(super.services);

  @override
  Future<LoginResponseModel> requestLogin(
    LoginRequestModel loginRequest,
  ) async => LoginResponseModel(
    accessToken: 'demo-access-token',
    refreshToken: 'demo-refresh-token',
  );
}
