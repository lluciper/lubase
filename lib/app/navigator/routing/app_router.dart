import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:lubase/modules/home/navigate/home_route.dart';
import 'package:lubase/modules/home/presenter/splash_screen/splash_screen.dart';

import '../../../modules/home/presenter/home_screen/home_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
@singleton
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        ...HomePageRouter.routes,
      ];
}
