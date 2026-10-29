import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LogLevel { info, debug, warning, error, print }

extension LogLevelExtension on LogLevel {
  String get name {
    switch (this) {
      case LogLevel.info:
        return 'INFO';
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.print:
        return 'PRINT';
    }
  }
}

class LoggerHelper {
  const LoggerHelper._();

  // No build flavors are configured, so gate on debug builds.
  static const bool _isEnabled = kDebugMode;

  static Logger loggerInfo = Logger(
    level: Level.info,
    printer: PrettyPrinter(
      methodCount: 0,
      printEmojis: false,
      colors: true,
      noBoxingByDefault: true,
    ),
  );
  static Logger loggerWarning = Logger(
    level: Level.warning,
    printer: PrettyPrinter(
      methodCount: 0,
      printEmojis: false,
      colors: true,
      noBoxingByDefault: true,
    ),
  );
  static Logger loggerError = Logger(
    level: Level.error,
    printer: PrettyPrinter(
      methodCount: 5,
      printEmojis: false,
      colors: true,
      noBoxingByDefault: true,
      excludePaths: ['package:lubase/utils/logger/logger_helper.dart'],
    ),
  );

  static void info(Object? message) {
    if (_isEnabled) {
      loggerInfo.i('[INFO]    :$message');
    }
  }

  static void warning(Object? message) {
    if (_isEnabled) {
      loggerWarning.w('[WARNING] :$message');
    }
  }

  static void error(Object? message, {StackTrace? stackTrace}) {
    if (_isEnabled) {
      loggerError.e('[ERROR]   :$message', stackTrace: stackTrace);
    }
  }

  static void print(Object? message) {
    if (_isEnabled) {
      stringify(message)
          .split('\n')
          .forEach(
            (element) => developer.log(element, name: LogLevel.print.name),
          );
    }
  }

  /// Maps and lists as indented JSON, anything else via `toString()`.
  static String stringify(Object? message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      final encoder = JsonEncoder.withIndent(
        '  ',
        (object) => object.toString(),
      );
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
