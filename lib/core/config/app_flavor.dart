import '../../data/services/api/api_constants.dart';

enum AppFlavorType { development, staging, production }

class AppFlavor {
  AppFlavor({required this.appFlavorType, required this.baseUrl});

  final AppFlavorType appFlavorType;
  final String baseUrl;
}

class AppFlavorValue {
  static final AppFlavor development = AppFlavor(
    appFlavorType: AppFlavorType.development,
    baseUrl: ApiConstants.devBaseUrl,
  );

  static final AppFlavor staging = AppFlavor(
    appFlavorType: AppFlavorType.staging,
    baseUrl: ApiConstants.stagingBaseUrl,
  );

  static final AppFlavor production = AppFlavor(
    appFlavorType: AppFlavorType.production,
    baseUrl: ApiConstants.prodBaseUrl,
  );

  /// `ENV` from `--dart-define-from-file=dart_defines/<env>.json` (or
  /// `--dart-define=ENV=…`). An unknown value fails at startup instead of
  /// silently shipping a build that points at the wrong server.
  static AppFlavor fromEnv(String env) => switch (env) {
    'development' => development,
    'staging' => staging,
    'production' => production,
    _ => throw ArgumentError.value(
      env,
      'ENV',
      'Use development | staging | production',
    ),
  };
}
