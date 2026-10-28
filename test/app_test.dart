import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/app.dart';
import 'package:lubase/app_router.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/view/features/home/home_page.dart';
import 'package:lubase/view/features/login/login_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helpers/fakes.dart';

/// The composition root (router, translations, theme) as `main.dart` runs it.
void main() {
  setUpAll(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Future<void> pumpApp(WidgetTester tester, {required bool loggedIn}) async {
    Dependence.register(
      FakeRepository(auth: FakeAuthRepository(loggedIn: loggedIn)),
    );
    registerAppRouter();
    addTearDown(getIt.reset);
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  }

  testWidgets('starts on Home with a token', (tester) async {
    await pumpApp(tester, loggedIn: true);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('starts on Login without a token', (tester) async {
    await pumpApp(tester, loggedIn: false);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('switching the language re-translates the app', (tester) async {
    await pumpApp(tester, loggedIn: true);
    expect(find.text('Home'), findsOneWidget);

    getIt<LocaleCubit>().setLocale(SupportLocale.vn);
    await tester.pumpAndSettle();

    expect(find.text('Trang chủ'), findsOneWidget);
  });

  testWidgets('switching the theme changes the brightness', (tester) async {
    await pumpApp(tester, loggedIn: true);

    getIt<ThemeCubit>().setBrightness(Brightness.dark);
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.byType(HomePage))).brightness,
      Brightness.dark,
    );
  });
}
