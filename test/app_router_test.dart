import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lubase/app_router.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/resources/generated/l10n.dart';
import 'package:lubase/view/features/detail/detail_page.dart';
import 'package:lubase/view/features/home/home_page.dart';
import 'package:lubase/view/features/login/login_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helpers/fakes.dart';

const _homeLink = 'lubase://app/home';
const _loginLink = 'lubase://app/login';

void main() {
  setUpAll(() async {
    await S.load(const Locale('en'));
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  late FakeAuthRepository auth;
  late GoRouter router;

  // Fixed pumps: async redirects and page transitions need a few frames.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  /// Starts the app as the OS does when it is launched by [link] (cold start).
  Future<void> launch(
    WidgetTester tester, {
    String link = '/',
    bool loggedIn = true,
  }) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = link;
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );
    auth = FakeAuthRepository(loggedIn: loggedIn);
    Dependence.register(FakeRepository(auth: auth));
    addTearDown(getIt.reset);
    router = createAppRouter(refreshListenable: auth.sessionEnded);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await settle(tester);
  }

  /// Delivers [link] the way the engine does while the app is running.
  Future<void> openLink(WidgetTester tester, String link) async {
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/navigation',
      const JSONMethodCodec().encodeMethodCall(
        MethodCall('pushRouteInformation', {'location': link, 'state': null}),
      ),
      (_) {},
    );
    await settle(tester);
  }

  testWidgets('cold-start link to home opens Home with title and welcome', (
    tester,
  ) async {
    await launch(tester, link: _homeLink);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text(S.current.home_title), findsOneWidget);
    expect(find.text(S.current.welcome), findsOneWidget);
  });

  testWidgets('cold-start link to login opens Login', (tester) async {
    await launch(tester, link: _loginLink);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('links received while running switch to Home and Login', (
    tester,
  ) async {
    await launch(tester, link: _loginLink);
    expect(find.byType(LoginPage), findsOneWidget);

    await openLink(tester, _homeLink);
    expect(find.byType(HomePage), findsOneWidget);

    await openLink(tester, _loginLink);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('without a token, a link to home lands on Login', (tester) async {
    await launch(tester, link: _homeLink, loggedIn: false);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  group('entry point', () {
    testWidgets('opening the app picks Home with a token', (tester) async {
      await launch(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('opening the app picks Login without a token', (tester) async {
      await launch(tester, loggedIn: false);
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('an unknown link goes to the entry point instead of an error', (
      tester,
    ) async {
      await launch(tester, link: 'lubase://app/does-not-exist');

      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('session end', () {
    testWidgets('session ending on Home moves to Login', (tester) async {
      await launch(tester, link: _homeLink);

      await auth
          .logout(); // e.g. interceptor cleared tokens after refresh failed
      await settle(tester);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('session ending on Detail moves to Login', (tester) async {
      await launch(tester, link: 'lubase://app/home/detail?id=1');

      await auth.logout();
      await settle(tester);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(DetailPage), findsNothing);
    });

    testWidgets('logout button returns to Login with no way back', (
      tester,
    ) async {
      await launch(tester, link: _homeLink);

      await tester.tap(find.byTooltip(S.current.logout));
      await settle(tester);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(router.canPop(), isFalse);
    });
  });

  group('detail param', () {
    String shown(String id) => S.current.detail_param(id);

    testWidgets('cold-start link shows the param, back goes to Home', (
      tester,
    ) async {
      await launch(tester, link: 'lubase://app/home/detail?id=42');

      expect(find.byType(DetailPage), findsOneWidget);
      expect(find.text(shown('42')), findsOneWidget);

      await tester.pageBack();
      await settle(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('a new link while running shows the new param', (tester) async {
      await launch(tester);

      await openLink(tester, 'lubase://app/home/detail?id=1');
      expect(find.text(shown('1')), findsOneWidget);

      await openLink(tester, 'lubase://app/home/detail?id=2');
      expect(find.text(shown('2')), findsOneWidget);
      expect(find.text(shown('1')), findsNothing);
    });

    testWidgets('URL-encoded param is shown decoded', (tester) async {
      await launch(tester, link: 'lubase://app/home/detail?id=Xin%20ch%C3%A0o');
      expect(find.text(shown('Xin chào')), findsOneWidget);
    });

    testWidgets('without a token, a link to detail lands on Login', (
      tester,
    ) async {
      await launch(
        tester,
        link: 'lubase://app/home/detail?id=42',
        loggedIn: false,
      );

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(DetailPage), findsNothing);
    });

    testWidgets('Home button opens Detail without a param', (tester) async {
      await launch(tester, link: _homeLink);

      await tester.tap(find.text(S.current.home_open_detail));
      await settle(tester);
      expect(find.text(S.current.detail_no_param), findsOneWidget);

      await tester.pageBack();
      await settle(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
