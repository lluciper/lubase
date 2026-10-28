import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/index.dart';
import 'index.dart';

/// The app's only container. [Dependence] fills it; tests fill it with fakes
/// through [Dependence.register] and empty it with `getIt.reset()`.
final getIt = GetIt.instance;

/// Composition root: builds the services once and registers them in [getIt].
class Dependence {
  static Future<void> initDependence(AppFlavor appFlavor) async {
    final sharedPreference = SharePreference(
      await SharedPreferences.getInstance(),
    );

    final secureStorage = SecureStorage(const FlutterSecureStorage());

    // iOS keeps Keychain items after uninstall, so a reinstall would start
    // "logged in" with stale tokens. Preferences are wiped on uninstall: use
    // them to detect the first launch of this install.
    if (sharedPreference.getString(LocalStorageKey.installed) == null) {
      await secureStorage.clearTokens();
      await sharedPreference.setString(LocalStorageKey.installed, '1');
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: appFlavor.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    dio.interceptors.addAll([
      DioInterceptor(dio, secureStorage),
      // Debug only: it stringifies every body on the UI isolate. Dio's own
      // LogInterceptor would also print tokens in release builds.
      if (kDebugMode) LoggerInterceptor(),
    ]);

    register(
      Repository(
        Services(DioClient(dio), sharedPreference, secureStorage),
        // shortcut: the dev API has no login endpoint yet, so development
        // logs in with fake tokens; set false once it does.
        demoLogin: appFlavor.appFlavorType == AppFlavorType.development,
      ),
    );
  }

  /// Registers [repository] and the app-wide state (language, theme).
  static void register(Repository repository) => getIt
    ..registerSingleton<Repository>(repository)
    ..registerLazySingleton(LocaleCubit.new, dispose: (it) => it.close())
    ..registerLazySingleton(ThemeCubit.new, dispose: (it) => it.close());
}
