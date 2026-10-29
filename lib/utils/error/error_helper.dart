import 'package:dio/dio.dart';

import '../../resources/generated/l10n.dart';

class ErrorHelper {
  ErrorHelper._();

  /// The message shown to users. Never `toString()`: that leaks internals.
  static String getError(Object? error) {
    if (error is! DioException) return S.current.unknown_error;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => S.current.timeout_error,
      DioExceptionType.connectionError => S.current.network_error,
      DioExceptionType.badResponse =>
        (error.response?.statusCode ?? 0) >= 500
            ? S.current.server_error
            : _serverMessage(error.response) ?? S.current.unknown_error,
      _ => S.current.unknown_error,
    };
  }

  /// The backend's own message for 4xx, from `msg` (or `error`) when it is a
  /// String. Rename the keys to match the backend.
  static String? _serverMessage(Response? response) {
    final data = response?.data;
    if (data is! Map) return null;
    final message = data['msg'] ?? data['error'];
    return message is String && message.isNotEmpty ? message : null;
  }
}
