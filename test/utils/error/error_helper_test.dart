import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/resources/generated/l10n.dart';
import 'package:lubase/utils/index.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

  group('ErrorHelper', () {
    final request = RequestOptions(path: '/x');
    DioException typed(DioExceptionType type) =>
        DioException(requestOptions: request, type: type);
    DioException status(int code, [Object? data]) => DioException(
      requestOptions: request,
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: request, statusCode: code, data: data),
    );

    test('timeouts and offline', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(ErrorHelper.getError(typed(type)), S.current.timeout_error);
      }
      expect(
        ErrorHelper.getError(typed(DioExceptionType.connectionError)),
        S.current.network_error,
      );
    });

    test('4xx shows the server message when it is a string', () {
      expect(
        ErrorHelper.getError(status(422, {'msg': 'Email đã tồn tại'})),
        'Email đã tồn tại',
      );
      expect(
        ErrorHelper.getError(status(400, {'error': 'Bad input'})),
        'Bad input',
      );
      expect(
        ErrorHelper.getError(
          status(400, {
            'error': {'code': 'X'},
          }),
        ),
        S.current.unknown_error,
      );
      expect(ErrorHelper.getError(status(404)), S.current.unknown_error);
    });

    test('5xx shows server_error, never the server text', () {
      expect(
        ErrorHelper.getError(status(500, {'msg': 'NullPointerException at …'})),
        S.current.server_error,
      );
    });

    test('non-API errors never leak toString()', () {
      expect(
        ErrorHelper.getError(Exception('secret detail')),
        S.current.unknown_error,
      );
      expect(ErrorHelper.getError(StateError('x')), S.current.unknown_error);
      expect(ErrorHelper.getError(null), S.current.unknown_error);
    });
  });
}
