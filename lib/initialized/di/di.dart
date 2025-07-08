import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lubase/app/managers/shared_pref_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../data/endpoint.dart';
import '../../data/login/api/login_api.dart';
import 'di.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection() => getIt.init();

@module
abstract class InjectableModule {
  @Named('BaseUrl')
  String get baseUrl => 'https://your.api.base.url/';

  @Named('Timeout')
  Duration get timeout => const Duration(seconds: 10);

  @preResolve
  Future<SharedPreferencesManager> get prefs =>
      SharedPreferencesManager.getInstance();

  @lazySingleton
  Dio dio(
    @Named('BaseUrl') String url,
    @Named('Timeout') Duration timeout,
  ) {
    return Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: timeout,
        contentType: 'application/json',
      ),
    )..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
  }

  @lazySingleton
  LoginApi loginApi(@Named('BaseUrl') String url) {
    return LoginApi(getIt<Dio>(), baseUrl: '$url${AuthEndpoint.base}');
  }
}
