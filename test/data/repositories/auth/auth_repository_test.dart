import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/data/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fakes.dart';

class _FakeDioClient implements DioClient {
  _FakeDioClient(this.response);

  final LoginResponseModel response;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async => response;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SecureStorage secureStorage;

  Future<AuthRepository> buildRepository(LoginResponseModel response) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    secureStorage = SecureStorage(const FlutterSecureStorage());
    return AuthRepository(
      Services(
        _FakeDioClient(response),
        SharePreference(await SharedPreferences.getInstance()),
        secureStorage,
      ),
    );
  }

  const request = LoginRequestModel(email: 'a@b.co', password: '12345678');

  test('login stores access and refresh tokens', () async {
    final repository = await buildRepository(
      LoginResponseModel(accessToken: 'access', refreshToken: 'refresh'),
    );

    final response = await repository.login(request);

    expect(response.accessToken, 'access');
    expect(await secureStorage.getAccessToken(), 'access');
    expect(await secureStorage.getRefreshToken(), 'refresh');
  });

  test('login without a refresh token stores only the access token', () async {
    final repository = await buildRepository(
      LoginResponseModel(accessToken: 'access'),
    );

    await repository.login(request);

    expect(await secureStorage.getAccessToken(), 'access');
    expect(await secureStorage.getRefreshToken(), isNull);
  });

  test('isLoggedIn is false without a token and true after login', () async {
    final repository = await buildRepository(
      LoginResponseModel(accessToken: 'access'),
    );

    expect(await repository.isLoggedIn(), isFalse);
    await repository.login(request);
    expect(await repository.isLoggedIn(), isTrue);
  });

  test('logout clears the tokens and signals the session end', () async {
    final repository = await buildRepository(
      LoginResponseModel(accessToken: 'access', refreshToken: 'refresh'),
    );
    await repository.login(request);
    var ended = 0;
    repository.sessionEnded.addListener(() => ended++);

    await repository.logout();

    expect(await repository.isLoggedIn(), isFalse);
    expect(await secureStorage.getRefreshToken(), isNull);
    expect(ended, 1);
  });

  test('unreadable storage counts as logged out instead of throwing', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = AuthRepository(
      Services(
        _FakeDioClient(LoginResponseModel(accessToken: 'access')),
        SharePreference(await SharedPreferences.getInstance()),
        BrokenSecureStorage(),
      ),
    );

    expect(await repository.isLoggedIn(), isFalse);
  });

  test(
    'DemoAuthRepository logs in without the API and stores tokens',
    () async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = SecureStorage(const FlutterSecureStorage());
      final repository = DemoAuthRepository(
        Services(
          _UnusedDioClient(),
          SharePreference(await SharedPreferences.getInstance()),
          secureStorage,
        ),
      );

      await repository.login(request);

      expect(await repository.isLoggedIn(), isTrue);
      expect(await secureStorage.getRefreshToken(), isNotNull);
      await repository.logout();
      expect(await repository.isLoggedIn(), isFalse);
    },
  );
}

/// Fails the test if the demo login reaches the network.
class _UnusedDioClient implements DioClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => fail(
    'DemoAuthRepository must not call the API: ${invocation.memberName}',
  );
}
