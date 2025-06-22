import 'package:auto_route/auto_route.dart';
import 'package:lubase/app/index.dart';

class HomePageRouter {
  HomePageRouter._();

  static List<AutoRoute> get routes => [
        AutoRoute(
          path: RoutingConstants.HOME,
          page: HomeRoute.page,
        ),
      ];
}
