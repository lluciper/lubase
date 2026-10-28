import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app_router.dart';
import 'core/index.dart';
import 'utils/index.dart';

/// From `--dart-define-from-file=dart_defines/<env>.json` (see .vscode/launch.json);
/// development when run without it.
const _env = String.fromEnvironment('ENV', defaultValue: 'development');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details); // console output / red screen in debug
    if (kReleaseMode) reportError(details.exception, details.stack);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stackTrace) {
    reportError(error, stackTrace);
    return true;
  };

  await Dependence.initDependence(AppFlavorValue.fromEnv(_env));
  registerAppRouter();
  runApp(const App());
}
