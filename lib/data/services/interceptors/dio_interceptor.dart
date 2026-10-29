import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../utils/network/network_helper.dart';
import '../../index.dart';

/// Adds the access token, normalizes network errors and refreshes the token on 401.
///
/// Not a [QueuedInterceptorsWrapper]: its onError queue deadlocks when a
/// retried request fails, and it serializes every request.
///
/// Needs dio >= 5.11: older versions did not observe errors thrown by async
/// callbacks, so a throwing interceptor left the request hanging forever.
class DioInterceptor extends Interceptor {
  DioInterceptor(
    this._dio,
    this._secureStorage, {
    Future<bool> Function({required String baseUrl}) checkConnectivity =
        NetworkHelper.checkConnectivity,
  }) : _checkConnectivity = checkConnectivity;

  final Dio _dio;
  final SecureStorage _secureStorage;
  final Future<bool> Function({required String baseUrl}) _checkConnectivity;
  late final _api = DioClient(_dio);

  /// The refresh in flight. Concurrent 401s wait on it instead of each
  /// refreshing, which would issue conflicting tokens.
  Completer<String>? _refreshCompleter;

  static const _retriedKey = 'auth_retried';

  /// Whether request requires authentication or not.
  bool isAuthenticatedPath(RequestOptions options) =>
      !ApiConstants.nonAuthenticatedPaths.contains(options.path);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (isAuthenticatedPath(options)) {
      final accessToken = await _secureStorage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    // No Content-Type here: Dio infers it from the body (JSON for maps,
    // multipart for FormData) and keeps one set explicitly on the request.
    options.headers.addAll(const {
      'Accept': 'application/json',
      'Accept-Language': 'vi',
    });
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      await _onError(err, handler);
    } catch (_) {
      // Keep the original API error (and its server message); Dio would
      // otherwise report this internal failure instead.
      if (!handler.isCompleted) handler.next(err);
    }
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;

    if (err.response?.statusCode == HttpStatus.unauthorized &&
        isAuthenticatedPath(requestOptions)) {
      await _handleUnauthorized(err, handler);
      return;
    }
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      handler.next(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout,
        ),
      );
      return;
    }
    // Only a failure without a response can mean "offline"; checking before
    // every request would add a DNS lookup to each call.
    if (err.response == null &&
        !await _checkConnectivity(baseUrl: requestOptions.baseUrl)) {
      handler.next(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (_isForceLogout(err.response)) {
      await _logout();
      handler.next(err);
      return;
    }
    // A fresh token was just issued for this retry: a 401 now comes from this
    // endpoint (e.g. a wrong current password), not from the session.
    if (options.extra[_retriedKey] == true) {
      handler.next(err);
      return;
    }

    try {
      await _refreshAccessToken(options);
    } catch (e) {
      // Session kept (offline, timeout, 5xx): report that failure, e.g.
      // "network error". Session ended: the router is already leaving.
      handler.next(e is DioException && !_isRefreshRejected(e) ? e : err);
      return;
    }

    // onRequest attaches the new token from storage.
    options.extra[_retriedKey] = true;
    // A FormData body can only be sent once.
    final data = options.data;
    if (data is FormData) options.data = data.clone();
    try {
      handler.resolve(await _dio.fetch(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<String> _refreshAccessToken(RequestOptions failed) async {
    // Another request refreshed after this one was sent: just retry.
    final current = await _secureStorage.getAccessToken();
    if (current != null &&
        current.isNotEmpty &&
        failed.headers['Authorization'] != 'Bearer $current') {
      return current;
    }

    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = _refreshCompleter = Completer<String>();
    _requestNewToken()
        .then(completer.complete, onError: completer.completeError)
        .whenComplete(() => _refreshCompleter = null);
    return completer.future;
  }

  Future<String> _requestNewToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw StateError('No refresh token');
      }
      final session = _secureStorage.clearedCount;
      final response = await _api.refreshToken(
        RefreshTokenRequestModel(refreshToken: refreshToken),
      );
      // Logged out while the refresh was in flight: saving these tokens would
      // bring the session back on the next app start.
      if (_secureStorage.clearedCount != session) {
        throw StateError('Session ended during refresh');
      }
      await _secureStorage.saveAccessToken(response.accessToken);
      final newRefreshToken = response.refreshToken;
      if (newRefreshToken != null) {
        await _secureStorage.saveRefreshToken(newRefreshToken);
      }
      return response.accessToken;
    } catch (e) {
      if (_isRefreshRejected(e)) await _logout();
      rethrow;
    }
  }

  /// Only a definite "no" ends the session: no refresh token, or the server
  /// rejecting it (expired or revoked, e.g. the server asks the user to log in
  /// again). Offline, timeouts and 5xx keep the tokens so the next call can
  /// refresh again. Adjust the statuses to the backend.
  bool _isRefreshRejected(Object error) =>
      error is! DioException ||
      const {400, 401, 403}.contains(error.response?.statusCode);

  // Clearing tokens notifies the router, which moves screens that need login
  // to Login (see `refreshListenable` in app_router.dart).
  Future<void> _logout() => _secureStorage.clearTokens();

  /// The server ends the session for good (e.g. the user was deleted): logout
  /// without trying a refresh. Reads the raw body, not a DTO, so an unexpected
  /// error shape cannot throw here. Rename the key to match the backend.
  bool _isForceLogout(Response? response) {
    var data = response?.data;
    if (data is String) {
      try {
        data = jsonDecode(data);
      } on FormatException {
        return false;
      }
    }
    return data is Map && data['forceLogout'] == true;
  }
}
