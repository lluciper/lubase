import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/resources/generated/l10n.dart';
import 'package:visibility_detector/visibility_detector.dart';

class _TestViewModel extends BaseViewModel<int> {
  _TestViewModel() : super(0);

  void increment() => emit(state + 1);
}

class _TestPage extends BasePage {
  const _TestPage(this.log);

  final List<String> log;

  @override
  BasePageState<_TestPage, _TestViewModel> createState() => _TestPageState();
}

class _TestPageState extends BasePageState<_TestPage, _TestViewModel> {
  @override
  _TestViewModel createViewModel() => _TestViewModel();

  @override
  void onInitState() {
    super.onInitState();
    widget.log.add('init');
  }

  @override
  void onStateCreated(BuildContext context) {
    super.onStateCreated(context);
    widget.log.add('created');
  }

  @override
  void onAppearedPage() {
    super.onAppearedPage();
    widget.log.add('appeared');
  }

  @override
  void onRefreshPage() {
    super.onRefreshPage();
    widget.log.add('refresh');
  }

  @override
  void onDispose() {
    widget.log.add('dispose');
    super.onDispose();
  }

  @override
  Color? get backgroundColor => Colors.red;

  @override
  Widget buildBody(BuildContext context) =>
      Text('count ${viewModel.listen(context, (s) => s)}');
}

/// A page that never watches its own ViewModel and reads `S.current` directly.
class _PlainPage extends BasePage {
  const _PlainPage();

  @override
  BasePageState<_PlainPage, _TestViewModel> createState() => _PlainPageState();
}

class _PlainPageState extends BasePageState<_PlainPage, _TestViewModel> {
  @override
  _TestViewModel createViewModel() => _TestViewModel();

  @override
  Widget buildBody(BuildContext context) => Text(S.current.language);
}

void main() {
  late List<String> log;

  setUpAll(() async {
    await S.load(const Locale('en'));
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  setUp(() {
    log = [];
    RefreshService.clear();
  });

  Future<_TestPageState> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: _TestPage(log)));
    await tester.pump(Duration.zero);
    return tester.state<_TestPageState>(find.byType(_TestPage));
  }

  bool isLoading() =>
      find.byType(ProgressIndicatorPlatform).evaluate().isNotEmpty;

  testWidgets(
    'renders buildBody inside a Scaffold and rebuilds on state change',
    (tester) async {
      final page = await pumpPage(tester);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('count 0'), findsOneWidget);

      page.viewModel.increment();
      await tester.pump(Duration.zero);
      expect(find.text('count 1'), findsOneWidget);
    },
  );

  testWidgets('lifecycle hooks run in order', (tester) async {
    await pumpPage(tester);
    expect(log, ['init', 'created', 'appeared']);

    await tester.pumpWidget(const SizedBox());
    expect(log.last, 'dispose');
  });

  testWidgets(
    'onRefreshPage runs once when the page is marked in RefreshService',
    (tester) async {
      RefreshService.addPage(_TestPage);
      await pumpPage(tester);
      expect(log, contains('refresh'));
      expect(RefreshService.hadRefresh('_TestPage'), isFalse);
    },
  );

  testWidgets(
    'subscribeLoadingFullScreen shows loading until the future ends',
    (tester) async {
      final page = await pumpPage(tester);
      final completer = Completer<int>();

      completer.future.subscribeLoadingFullScreen(page);
      await tester.pump(Duration.zero);
      expect(isLoading(), isTrue);

      completer.complete(1);
      await tester.pump(Duration.zero);
      expect(isLoading(), isFalse);
    },
  );

  testWidgets('loading stays until every subscribed future is done', (
    tester,
  ) async {
    final page = await pumpPage(tester);
    final first = Completer<int>();
    final second = Completer<int>();

    first.future.subscribeLoadingFullScreen(page);
    second.future.subscribeLoadingFullScreen(page);
    await tester.pump(Duration.zero);

    first.complete(1);
    await tester.pump(Duration.zero);
    expect(isLoading(), isTrue);

    second.complete(2);
    await tester.pump(Duration.zero);
    expect(isLoading(), isFalse);
  });

  testWidgets('subscribeOnSuccess delivers the value', (tester) async {
    final page = await pumpPage(tester);
    int? value;
    await Future.value(7).subscribeOnSuccess(page, success: (v) => value = v);
    expect(value, 7);
  });

  testWidgets('subscribeHandleError hides loading and shows the error dialog', (
    tester,
  ) async {
    final page = await pumpPage(tester);

    Future<int?>.error(
      Exception('boom'),
    ).subscribeLoadingFullScreen(page).subscribeHandleError(page);
    await tester.pumpAndSettle();

    expect(isLoading(), isFalse);
    expect(find.text(S.current.unknown_error), findsOneWidget);
  });

  testWidgets('subscribeHandleError uses the custom onError when given', (
    tester,
  ) async {
    final page = await pumpPage(tester);
    Object? received;

    await Future<int?>.error(
      'custom',
    ).subscribeHandleError(page, onError: (e) => received = e);
    await tester.pumpAndSettle();

    expect(received, 'custom');
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('only one error dialog is shown when several futures fail', (
    tester,
  ) async {
    final page = await pumpPage(tester);

    Future<int?>.error(Exception('a')).subscribeHandleError(page);
    Future<int?>.error(Exception('b')).subscribeHandleError(page);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('a future finishing after the page is disposed does not throw', (
    tester,
  ) async {
    final page = await pumpPage(tester);
    final success = Completer<int?>();
    final failure = Completer<int?>();

    success.future.subscribeLoadingFullScreen(page);
    failure.future.subscribeLoadingFullScreen(page).subscribeHandleError(page);
    await tester.pumpWidget(const SizedBox());

    success.complete(1);
    failure.completeError(Exception('late'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('backgroundColor override is applied to the Scaffold', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      Colors.red,
    );
  });

  testWidgets(
    'the ViewModel lives as long as the page even if nothing watches it',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: _PlainPage()));
      final page = tester.state<_PlainPageState>(find.byType(_PlainPage));
      final viewModel = page.viewModel..increment();
      await tester.pump(Duration.zero);
      await tester.pump(Duration.zero);

      expect(page.viewModel, same(viewModel));
      expect(viewModel.state, 1);
      expect(viewModel.isClosed, isFalse);
    },
  );

  testWidgets('closing the page closes its ViewModel', (tester) async {
    final page = await pumpPage(tester);
    final viewModel = page.viewModel;

    await tester.pumpWidget(const SizedBox());

    expect(viewModel.isClosed, isTrue);
  });

  testWidgets('subscribeHandleError works on a non-nullable Future', (
    tester,
  ) async {
    final page = await pumpPage(tester);

    Future<int>.error(
      Exception('boom'),
    ).subscribeLoadingFullScreen(page).subscribeHandleError(page);
    await tester.pumpAndSettle();

    expect(find.text(S.current.unknown_error), findsOneWidget);
  });

  testWidgets('switching LocaleCubit re-renders S.current texts', (
    tester,
  ) async {
    final localeCubit = LocaleCubit();
    addTearDown(localeCubit.close);
    await tester.pumpWidget(
      BlocBuilder<LocaleCubit, Locale>(
        bloc: localeCubit,
        builder: (context, locale) => MaterialApp(
          locale: locale,
          supportedLocales: SupportLocale.support,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const _PlainPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);

    localeCubit.setLocale(SupportLocale.vn);
    await tester.pumpAndSettle();
    expect(find.text('Ngôn ngữ'), findsOneWidget);

    await S.load(const Locale('en'));
  });

  testWidgets(
    'subscribeOnSuccess skips the callback after the page is disposed',
    (tester) async {
      final page = await pumpPage(tester);
      final completer = Completer<int>();
      var called = false;

      completer.future.subscribeOnSuccess(page, success: (_) => called = true);
      await tester.pumpWidget(const SizedBox());
      completer.complete(1);
      await tester.pump(Duration.zero);

      expect(called, isFalse);
    },
  );

  testWidgets('a failing future keeps the overlay while another one runs', (
    tester,
  ) async {
    final page = await pumpPage(tester);
    final failing = Completer<int?>();
    final running = Completer<int?>();

    failing.future
        .subscribeLoadingFullScreen(page)
        .subscribeHandleError(page, onError: (_) {});
    running.future.subscribeLoadingFullScreen(page).subscribeHandleError(page);
    await tester.pump(Duration.zero);

    failing.completeError(Exception('fail'));
    await tester.pump(Duration.zero);
    expect(isLoading(), isTrue);

    running.complete(1);
    await tester.pump(Duration.zero);
    expect(isLoading(), isFalse);
  });
}
