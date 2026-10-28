import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lubase/app_router.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/data/index.dart';
import 'package:lubase/resources/generated/l10n.dart';
import 'package:lubase/view/features/detail/detail_page.dart';
import 'package:lubase/view/features/home/home_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../helpers/fakes.dart';

void main() {
  late FakeAuthRepository auth;
  late GoRouter router;

  setUpAll(() async {
    await S.load(const Locale('en'));
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  setUp(() => auth = FakeAuthRepository());

  Future<void> pumpLoginPage(
    WidgetTester tester, {
    String link = '/login',
  }) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = link;
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );
    Dependence.register(FakeRepository(auth: auth));
    addTearDown(getIt.reset);
    router = createAppRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);
  Finder loginButton() =>
      find.widgetWithText(ElevatedButton, S.current.login_button);

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(field(S.current.email), 'user@example.com');
    await tester.enterText(field(S.current.password), '12345678');
    await tester.pump();
  }

  Future<void> tapLogin(WidgetTester tester) async {
    await tester.ensureVisible(loginButton());
    await tester.tap(loginButton());
    await tester.pumpAndSettle();
  }

  testWidgets('password field hides its text', (tester) async {
    await pumpLoginPage(tester);
    final editable = tester.widget<EditableText>(
      find.descendant(
        of: field(S.current.password),
        matching: find.byType(EditableText),
      ),
    );
    expect(editable.obscureText, isTrue);
  });

  testWidgets('invalid email shows the validation error', (tester) async {
    await pumpLoginPage(tester);
    await tester.enterText(field(S.current.email), 'not-an-email');
    await tester.pump();
    expect(find.text(S.current.email_invalid), findsOneWidget);
  });

  testWidgets('login button is enabled only when the form is valid', (
    tester,
  ) async {
    await pumpLoginPage(tester);
    expect(tester.widget<ElevatedButton>(loginButton()).onPressed, isNull);

    await fillValidForm(tester);
    expect(tester.widget<ElevatedButton>(loginButton()).onPressed, isNotNull);
  });

  testWidgets('login sends the typed credentials', (tester) async {
    await pumpLoginPage(tester);
    await fillValidForm(tester);
    await tapLogin(tester);

    expect(auth.requests, hasLength(1));
    expect(auth.requests.single.email, 'user@example.com');
    expect(auth.requests.single.password, '12345678');
  });

  testWidgets('a successful login replaces the stack with Home', (
    tester,
  ) async {
    await pumpLoginPage(tester);
    await fillValidForm(tester);
    await tapLogin(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(router.canPop(), isFalse);
  });

  testWidgets('a rejected login shows the server message', (tester) async {
    final request = RequestOptions(path: ApiConstants.login);
    auth.onLogin = (_) async => throw DioException(
      requestOptions: request,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: request,
        statusCode: 401,
        data: {'msg': 'Sai mật khẩu'},
      ),
    );
    await pumpLoginPage(tester);
    await fillValidForm(tester);
    await tapLogin(tester);

    expect(find.text('Sai mật khẩu'), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets(
    'a deep link that needed login continues to its screen after login',
    (tester) async {
      await pumpLoginPage(tester, link: 'lubase://app/home/detail?id=42');
      expect(find.byType(DetailPage), findsNothing); // the guard showed Login

      await fillValidForm(tester);
      await tapLogin(tester);

      expect(find.text(S.current.detail_param('42')), findsOneWidget);
      expect(router.canPop(), isTrue); // Home is below, like a normal deep link
    },
  );

  testWidgets('a "from" that is not an in-app path falls back to Home', (
    tester,
  ) async {
    await pumpLoginPage(
      tester,
      link: '/login?from=${Uri.encodeComponent('https://evil.example')}',
    );

    await fillValidForm(tester);
    await tapLogin(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });
}
