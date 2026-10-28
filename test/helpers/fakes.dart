import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lubase/data/index.dart';

/// In-memory auth for tests: logged out by default, login succeeds unless
/// [onLogin] says otherwise. When `AuthRepository` gains a member, add it here
/// once instead of in every test.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.loggedIn = false, this.onLogin});

  bool loggedIn;
  Future<LoginResponseModel> Function(LoginRequestModel request)? onLogin;
  final requests = <LoginRequestModel>[];
  final _sessionEnded = ValueNotifier<int>(0);

  @override
  Listenable get sessionEnded => _sessionEnded;

  @override
  Future<bool> isLoggedIn() async => loggedIn;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    requests.add(request);
    final response =
        await (onLogin?.call(request) ??
            Future.value(LoginResponseModel(accessToken: 'token')));
    loggedIn = true;
    return response;
  }

  @override
  Future<LoginResponseModel> requestLogin(LoginRequestModel request) =>
      throw UnimplementedError('FakeAuthRepository overrides login itself');

  /// Same effect as the interceptor clearing tokens or the user logging out.
  @override
  Future<void> logout() async {
    loggedIn = false;
    _sessionEnded.value++;
  }
}

class FakeRepository implements Repository {
  FakeRepository({AuthRepository? auth}) : auth = auth ?? FakeAuthRepository();

  @override
  final AuthRepository auth;
}

/// Storage whose reads fail, like a Keychain that is locked or corrupted.
class BrokenSecureStorage extends SecureStorage {
  BrokenSecureStorage() : super(const FlutterSecureStorage());

  @override
  Future<String?> getAccessToken() =>
      Future.error(PlatformException(code: 'keychain-unavailable'));
}
