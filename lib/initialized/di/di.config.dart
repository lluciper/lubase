// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lubase/app/managers/shared_pref_manager.dart' as _i262;
import 'package:lubase/app/navigator/routing/app_router.dart' as _i143;
import 'package:lubase/data/login/api/login_api.dart' as _i993;
import 'package:lubase/data/login/repositories/login_repository_impl.dart'
    as _i505;
import 'package:lubase/domain/login/repositories/login_repository.dart'
    as _i932;
import 'package:lubase/domain/login/usecases/login_usecase.dart' as _i34;
import 'package:lubase/initialized/di/di.dart' as _i710;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    await gh.factoryAsync<_i262.SharedPreferencesManager>(
      () => injectableModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i143.AppRouter>(() => _i143.AppRouter());
    gh.factory<String>(
      () => injectableModule.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.factory<Duration>(
      () => injectableModule.timeout,
      instanceName: 'Timeout',
    );
    gh.lazySingleton<_i361.Dio>(() => injectableModule.dio(
          gh<String>(instanceName: 'BaseUrl'),
          gh<Duration>(instanceName: 'Timeout'),
        ));
    gh.lazySingleton<_i993.LoginApi>(
        () => injectableModule.loginApi(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i932.LoginRepository>(
        () => _i505.LoginRepositoryImpl(gh<_i993.LoginApi>()));
    gh.lazySingleton<_i34.LoginUseCase>(
        () => _i34.LoginUseCase(gh<_i932.LoginRepository>()));
    return this;
  }
}

class _$InjectableModule extends _i710.InjectableModule {}
