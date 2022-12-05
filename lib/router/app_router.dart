import 'package:flutter/material.dart';
import 'package:name/screens/custom_screen.dart';

import '../main.dart';
import 'custom_page_router.dart';

class AppRouter {
  late Widget startScreen;

  Route? onGenerateRoute(RouteSettings settings) {
    startScreen = const MyApp();
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => startScreen,
        );
      case 'myHomePage':
        return MaterialPageRoute(
          builder: (_) => MyHomePage(),
        );
      case 'customScreen':
        return CustomPageRoute(
            direction: AxisDirection.down, child: const CustomScreen());
      default:
        return null;
    }
  }
}
