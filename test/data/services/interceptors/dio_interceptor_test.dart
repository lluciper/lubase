import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/data/index.dart';

import '../../../helpers/fakes.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.onFetch);

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => onFetch(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SecureStorage storage;
  late Dio dio;
  late int refreshCalls;
  late int refreshStatus; // 200 = new tokens, otherwise this status
  late Object? refreshThrows; // thrown instead: offline, timeout
  late String acceptedToken;
  late Future<void> Function(RequestOptions options)? beforeApiResponse;
  late Map<String, dynamic> unauthorizedBody;
  late int connectivityChecks;
  late bool online;
  late Completer<void>? refreshGate;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      LocalStorageKey.accessToken: 'old',
      LocalStorageKey.refreshToken: 'refresh-1',
    });
    storage = SecureStorage(const FlutterSecureStorage());
    refreshCalls = 0;
    refreshStatus = 200;
    refreshThrows = null;
    acceptedToken = 'new';
    beforeApiResponse = null;
    unauthorizedBody = {};
    connectivityChecks = 0;
    online = true;
    refreshGate = null;

    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = _FakeAdapter((options) async {
        if (options.path == ApiConstants.refreshToken) {
          refreshCalls++;
          await refreshGate?.future;
          // Slow refresh so concurrent 401s overlap with it.
          await Future<void>.delayed(const Duration(milliseconds: 20));
          if (refreshThrows case final error?) throw error;
          return refreshStatus == 200
              ? _json(200, {
                  'access_token': 'new',
                  'refresh_token': 'refresh-2',
                })
              : _json(refreshStatus, {});
        }
        await beforeApiResponse?.call(options);
        return options.headers['Authorization'] == 'Bearer $acceptedToken'
            ? _json(200, {'path': options.path})
            : _json(401, unauthorizedBody);
      });
    dio.interceptors.add(
      DioInterceptor(
        dio,
        storage,
        checkConnectivity: ({required baseUrl}) async {
          connectivityChecks++;
          return online;
        },
      ),
    );
  });

  Matcher isStatus(int code) => isA<DioException>().having(
    (e) => e.response?.statusCode,
    'statusCode',
    code,
  );

  test(
    'concurrent 401s share one refresh, then all retry with the new token',
    () async {
      final responses = await Future.wait([
        dio.get<dynamic>('/a'),
        dio.get<dynamic>('/b'),
        dio.get<dynamic>('/c'),
      ]);

      expect(responses.map((r) => r.statusCode), everyElement(200));
      expect(refreshCalls, 1);
      expect(await storage.getAccessToken(), 'new');
      expect(await storage.getRefreshToken(), 'refresh-2');
    },
  );

  test(
    'a rejected refresh fails every waiting request once and ends the session',
    () async {
      refreshStatus = 401; // refresh token expired or revoked by the server
      var sessionEnded = 0;
      storage.tokensCleared.addListener(() => sessionEnded++);

      final results = await Future.wait([
        dio.get<dynamic>('/a').then<Object>((r) => r, onError: (Object e) => e),
        dio.get<dynamic>('/b').then<Object>((r) => r, onError: (Object e) => e),
      ]);

      expect(results, everyElement(isStatus(401)));
      expect(refreshCalls, 1);
      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
      expect(sessionEnded, greaterThan(0)); // the router moves to Login on this
    },
  );

  test(
    'a 401 after a successful refresh is reported without logging out',
    () async {
      acceptedToken = 'never'; // e.g. wrong current password on this endpoint
      var sessionEnded = 0;
      storage.tokensCleared.addListener(() => sessionEnded++);

      await expectLater(dio.get<dynamic>('/a'), throwsA(isStatus(401)));

      expect(refreshCalls, 1);
      expect(sessionEnded, 0);
      expect(await storage.getAccessToken(), 'new');
      expect(await storage.getRefreshToken(), 'refresh-2');
    },
  );

  test('a 401 for a token that was already refreshed just retries', () async {
    // Another request refreshes while this one is in flight with 'old'.
    beforeApiResponse = (options) async {
      if (options.headers['Authorization'] == 'Bearer old') {
        await storage.saveAccessToken('new');
      }
    };

    final response = await dio.get<dynamic>('/a');
    expect(response.statusCode, 200);
    expect(refreshCalls, 0);
  });

  test('401 on a non-authenticated path is not refreshed', () async {
    await expectLater(
      dio.post<dynamic>(ApiConstants.login),
      throwsA(isStatus(401)),
    );
    expect(refreshCalls, 0);
  });

  test('forceLogout clears tokens without refreshing', () async {
    unauthorizedBody = {'forceLogout': true};

    await expectLater(dio.get<dynamic>('/a'), throwsA(isStatus(401)));
    expect(refreshCalls, 0);
    expect(await storage.getAccessToken(), isNull);
  });

  test('requests carry the stored access token', () async {
    acceptedToken = 'old';
    final response = await dio.get<dynamic>('/a');
    expect(response.requestOptions.headers['Authorization'], 'Bearer old');
    expect(refreshCalls, 0);
  });

  test('2xx responses other than 200 are successful', () async {
    acceptedToken = 'old';
    beforeApiResponse = null;
    dio.httpClientAdapter = _FakeAdapter((options) async => _json(201, {}));

    final response = await dio.post<dynamic>('/items');
    expect(response.statusCode, 201);
  });

  group('request headers', () {
    late String? sentContentType;

    setUp(() {
      acceptedToken = 'old';
      beforeApiResponse = (options) async =>
          sentContentType = options.contentType;
    });

    test('JSON bodies are sent as application/json', () async {
      await dio.post<dynamic>('/items', data: {'name': 'a'});
      expect(sentContentType, startsWith('application/json'));
    });

    test('an explicit content type (form-urlencoded) is kept', () async {
      await dio.post<dynamic>(
        '/token',
        data: {'grant_type': 'password'},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      expect(sentContentType, startsWith(Headers.formUrlEncodedContentType));
    });

    test('FormData uploads keep the multipart content type', () async {
      await dio.post<dynamic>('/upload', data: FormData.fromMap({'f': 'x'}));
      expect(sentContentType, startsWith('multipart/form-data'));
    });
  });

  group('connectivity', () {
    test('a request is sent without a connectivity check first', () async {
      acceptedToken = 'old';
      await dio.get<dynamic>('/a');
      expect(connectivityChecks, 0);
    });

    test('a server error response skips the connectivity check', () async {
      dio.httpClientAdapter = _FakeAdapter((options) async => _json(500, {}));

      await expectLater(dio.get<dynamic>('/a'), throwsA(isStatus(500)));
      expect(connectivityChecks, 0);
    });

    test(
      'a failure without a response while offline is a connectionError',
      () async {
        online = false;
        dio.httpClientAdapter = _FakeAdapter(
          (options) async => throw const SocketException('Failed host lookup'),
        );

        await expectLater(
          dio.get<dynamic>('/a'),
          throwsA(
            isA<DioException>().having(
              (e) => e.type,
              'type',
              DioExceptionType.connectionError,
            ),
          ),
        );
      },
    );
  });

  // A throwing interceptor used to hang requests (dio < 5.11): time out
  // quickly instead of waiting for the suite timeout if that ever returns.
  const noHang = Duration(seconds: 2);

  group('robustness', () {
    test(
      'a 401 with an unexpected body shape still refreshes and retries',
      () async {
        unauthorizedBody = {
          'success': 0,
          'error': {'code': 'TOKEN_EXPIRED'},
        };

        final response = await dio.get<dynamic>('/a').timeout(noHang);

        expect(response.statusCode, 200);
        expect(refreshCalls, 1);
      },
    );

    test(
      'a storage failure while adding the token fails the request',
      () async {
        final broken = Dio(BaseOptions(baseUrl: 'https://api.test'))
          ..httpClientAdapter = _FakeAdapter((options) async => _json(200, {}));
        broken.interceptors.add(
          DioInterceptor(
            broken,
            BrokenSecureStorage(),
            checkConnectivity: ({required baseUrl}) async => true,
          ),
        );

        await expectLater(
          broken.get<dynamic>('/a').timeout(noHang),
          throwsA(isA<DioException>()),
        );
      },
    );

    test('a FormData upload is resent after a refresh', () async {
      final response = await dio
          .post<dynamic>('/upload', data: FormData.fromMap({'f': 'x'}))
          .timeout(noHang);

      expect(response.statusCode, 200);
      expect(refreshCalls, 1);
    });

    test(
      'logging out during a refresh does not bring the session back',
      () async {
        refreshGate = Completer<void>();
        final pending = dio
            .get<dynamic>('/a')
            .then<Object>((r) => r, onError: (Object e) => e);
        for (var i = 0; refreshCalls == 0 && i < 100; i++) {
          await Future<void>.delayed(Duration.zero);
        }
        expect(refreshCalls, 1, reason: 'refresh must be in flight');

        await storage.clearTokens(); // the user taps Log out
        refreshGate!.complete();

        expect(await pending.timeout(noHang), isStatus(401));
        expect(await storage.getAccessToken(), isNull);
        expect(await storage.getRefreshToken(), isNull);
      },
    );
  });

  group('refresh fails without ending the session', () {
    late int sessionEnded;

    setUp(() {
      sessionEnded = 0;
      storage.tokensCleared.addListener(() => sessionEnded++);
    });

    Future<void> expectSessionKeptThenRecovers(
      Matcher error, {
      bool offline = false,
    }) async {
      online = !offline;
      await expectLater(dio.get<dynamic>('/a').timeout(noHang), throwsA(error));
      expect(sessionEnded, 0);
      expect(await storage.getAccessToken(), 'old');
      expect(await storage.getRefreshToken(), 'refresh-1');

      // Network/server back: the next call refreshes and the user carries on.
      online = true;
      refreshThrows = null;
      refreshStatus = 200;
      final response = await dio.get<dynamic>('/a').timeout(noHang);
      expect(response.statusCode, 200);
    }

    test('server error (5xx) on refresh', () async {
      refreshStatus = 503;
      await expectSessionKeptThenRecovers(isStatus(503));
    });

    test('timeout on refresh', () async {
      refreshThrows = DioException(
        requestOptions: RequestOptions(path: ApiConstants.refreshToken),
        type: DioExceptionType.receiveTimeout,
      );
      await expectSessionKeptThenRecovers(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionTimeout,
        ),
      );
    });

    test('offline on refresh', () async {
      refreshThrows = const SocketException('Failed host lookup');
      await expectSessionKeptThenRecovers(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
        offline: true,
      );
    });
  });

  test('no refresh token stored ends the session', () async {
    await const FlutterSecureStorage().delete(
      key: LocalStorageKey.refreshToken,
    );
    var sessionEnded = 0;
    storage.tokensCleared.addListener(() => sessionEnded++);

    await expectLater(
      dio.get<dynamic>('/a').timeout(noHang),
      throwsA(isStatus(401)),
    );

    expect(refreshCalls, 0);
    expect(sessionEnded, 1);
    expect(await storage.getAccessToken(), isNull);
  });
}
