import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/resources/generated/l10n.dart';

void main() {
  late BuildContext context;

  setUpAll(() => S.load(const Locale('en')));

  Future<void> pumpHost(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (ctx) {
          context = ctx;
          return const SizedBox();
        },
      ),
    ),
  );

  testWidgets('alert shows content and returns ok when OK is tapped', (
    tester,
  ) async {
    await pumpHost(tester);
    final result = DialogPlatform(
      content: 'Hello',
      title: 'Title',
    ).show(context);
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text(S.current.cancel_button_dialog), findsNothing);

    await tester.tap(find.text(S.current.ok_button_dialog));
    await tester.pumpAndSettle();
    expect(await result, ActionDialog.ok);
  });

  testWidgets('confirm uses default button labels', (tester) async {
    await pumpHost(tester);
    final result = DialogPlatform(
      content: 'Sure?',
      type: TypeDialog.confirm,
    ).show(context);
    await tester.pumpAndSettle();

    await tester.tap(find.text(S.current.cancel_button_dialog));
    await tester.pumpAndSettle();
    expect(await result, ActionDialog.cancel);
  });

  testWidgets('confirm keeps custom button labels', (tester) async {
    await pumpHost(tester);
    DialogPlatform(
      content: 'Sure?',
      type: TypeDialog.confirm,
      btnOK: 'Yes',
      btnCancel: 'No',
    ).show(context);
    await tester.pumpAndSettle();

    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });

  testWidgets('accepts a Widget as content', (tester) async {
    await pumpHost(tester);
    DialogPlatform(content: const Icon(Icons.info)).show(context);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.info), findsOneWidget);
  });

  testWidgets('tapping outside returns onDismissDialog value (cancel)', (
    tester,
  ) async {
    await pumpHost(tester);
    final result = DialogPlatform(content: 'Hello').show(context);
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(await result, ActionDialog.cancel);
  });

  testWidgets('renders one platform dialog, not one nested in another', (
    tester,
  ) async {
    await pumpHost(tester);
    DialogPlatform(content: 'Hello').show(context);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('show(result:) is called with the pop result', (tester) async {
    await pumpHost(tester);
    final results = <Object?>[];
    DialogPlatform(
      content: 'Hello',
    ).show(context, result: (didPop, result) => results.add(result));
    await tester.pumpAndSettle();

    await tester.tap(find.text(S.current.ok_button_dialog));
    await tester.pumpAndSettle();
    expect(results, [ActionDialog.ok]);
  });
}
