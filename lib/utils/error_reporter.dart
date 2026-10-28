import 'package:flutter/foundation.dart';

import 'logger_helper.dart';

/// Single sink for uncaught errors (framework and async), wired in main.dart.
// shortcut: only logs (LoggerHelper in debug, device log in release); send to
// Crashlytics/Sentry here once the project picks a crash service.
void reportError(Object error, StackTrace? stackTrace) {
  if (kReleaseMode) {
    debugPrint('Uncaught error: $error\n$stackTrace');
  } else {
    LoggerHelper.error('$error', stackTrace: stackTrace);
  }
}
