import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'core/index.dart';
import 'data/index.dart';
import 'view/features/detail/detail_page.dart';
import 'view/features/home/home_page.dart';
import 'view/features/login/login_page.dart';

part 'app_router.g.dart';

/// Deep links (`lubase://app/<path>`) arrive here as full URIs;
/// go_router matches only the path, so `lubase://app/home` opens `/home`.
/// [refreshListenable] re-runs the login guards: when the session ends, a
/// screen that needs login moves to Login.
/// The app reads it from `getIt` ([registerAppRouter]); tests may build a fresh
/// router per test.
GoRouter createAppRouter({Listenable? refreshListenable}) => GoRouter(
  routes: $appRoutes,
  refreshListenable: refreshListenable,
  // Unknown deep link or location: back to the entry point, which picks the
  // first screen.
  onException: (_, _, router) => router.go(SplashRoute.path),
);

/// Called by main.dart after `Dependence`; `getIt.reset()` disposes it.
void registerAppRouter() => getIt.registerLazySingleton<GoRouter>(
  () =>
      createAppRouter(refreshListenable: getIt<Repository>().auth.sessionEnded),
  dispose: (router) => router.dispose(),
);

/// Path and query only: deep links arrive with the app's scheme and host.
String _inAppLocation(Uri uri) =>
    Uri(path: uri.path, query: uri.hasQuery ? uri.query : null).toString();

Future<bool> _isLoggedIn(BuildContext context) =>
    getIt<Repository>().auth.isLoggedIn();

class RouterPath {
  RouterPath._();
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const detail = 'detail';
}

/// Entry point: picks the first screen (the native splash shows meanwhile).
@TypedGoRoute<SplashRoute>(path: SplashRoute.path)
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();
  static const path = RouterPath.splash;

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async =>
      await _isLoggedIn(context)
      ? const HomeRoute().location
      : const LoginRoute().location;
}

/// Top level, not nested under `/`: the entry redirect would otherwise also
/// run for `/login` and loop.
@TypedGoRoute<LoginRoute>(path: LoginRoute.path)
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute({this.from});
  static const path = RouterPath.login;

  /// Where to continue after login: the screen a login guard sent the user
  /// away from (e.g. a deep link). Validated by LoginPage.
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LoginPage(from: from);
}

@TypedGoRoute<HomeRoute>(
  path: HomeRoute.path,
  routes: [TypedGoRoute<DetailRoute>(path: DetailRoute.path)],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  static const path = RouterPath.home;

  /// Without a stored token (deep link included) the user goes to Login, which
  /// continues to the requested screen afterwards.
  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async =>
      await _isLoggedIn(context)
      ? null
      : LoginRoute(from: _inAppLocation(state.uri)).location;

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

/// Nested under Home: back goes to Home and Home's login guard applies.
/// Fields that are not in the path become query params:
/// `lubase://app/home/detail?id=42` → `DetailRoute(id: '42')`.
class DetailRoute extends GoRouteData with $DetailRoute {
  const DetailRoute({this.id});
  static const path = RouterPath.detail;
  final String? id;

  @override
  // Keyed by id: go_router reuses the page for the same route, and a Bloc page
  // keeps its ViewModel, so a new id needs a new page.
  Widget build(BuildContext context, GoRouterState state) =>
      DetailPage(key: ValueKey(id), id: id);
}
