import 'package:flutter/foundation.dart';

import '../../../utils/error/error_reporter.dart';
import '../../models/auth/login_request_model.dart';
import '../../models/auth/login_response_model.dart';
import '../../services/services.dart';

class AuthRepository {
  AuthRepository(this._services);

  final Services _services;

  /// Logs in and stores the tokens that DioInterceptor attaches and refreshes.
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    final response = await requestLogin(loginRequest);
    await _services.secureStorage.saveAccessToken(response.accessToken);
    final refreshToken = response.refreshToken;
    if (refreshToken != null) {
      await _services.secureStorage.saveRefreshToken(refreshToken);
    }
    return response;
  }

  /// Whether an access token is stored. It may be expired: DioInterceptor
  /// refreshes it on the first 401.
  Future<bool> isLoggedIn() async {
    try {
      return (await _services.secureStorage.getAccessToken())?.isNotEmpty ??
          false;
    } catch (e, s) {
      // Unreadable storage: ask to log in again. A throwing login guard would
      // loop forever through the router's onException.
      reportError(e, s);
      return false;
    }
  }

  Future<void> logout() => _services.secureStorage.clearTokens();

  /// The login API call; [DemoAuthRepository] replaces it in development.
  @protected
  Future<LoginResponseModel> requestLogin(LoginRequestModel loginRequest) =>
      _services.dio.login(loginRequest);

  /// Fires when the session ends: [logout], or DioInterceptor clearing tokens
  /// after a failed refresh / forceLogout.
  Listenable get sessionEnded => _services.secureStorage.tokensCleared;
}
