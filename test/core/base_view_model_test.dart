import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/data/index.dart';

import '../helpers/fakes.dart';

class _CounterViewModel extends BaseViewModel<({int a, int b})> {
  _CounterViewModel() : super((a: 0, b: 0));

  void incrementA() => emit((a: state.a + 1, b: state.b));

  void incrementB() => emit((a: state.a, b: state.b + 1));

  Repository readRepository() => repository;
}

void main() {
  tearDown(getIt.reset);

  test('the constructor provides the initial state', () {
    expect(_CounterViewModel().state, (a: 0, b: 0));
  });

  test('repository getter reads the Repository in getIt', () {
    final repository = FakeRepository();
    Dependence.register(repository);
    expect(_CounterViewModel().readRepository(), same(repository));
  });

  test('LoadingWrapperViewModel toggles loading state', () {
    final viewModel = LoadingWrapperViewModel();

    expect(viewModel.state, isFalse);
    viewModel.showLoading();
    expect(viewModel.state, isTrue);
    viewModel.dismissLoading();
    expect(viewModel.state, isFalse);
  });

  testWidgets('listen(context) rebuilds only when the selected value changes', (
    tester,
  ) async {
    var builds = 0;
    final viewModel = _CounterViewModel();
    addTearDown(viewModel.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: viewModel,
          child: Builder(
            builder: (context) {
              builds++;
              return Text('a=${viewModel.listen(context, (s) => s.a)}');
            },
          ),
        ),
      ),
    );
    expect(find.text('a=0'), findsOneWidget);
    expect(builds, 1);

    viewModel.incrementB();
    await tester.pump(Duration.zero);
    expect(builds, 1, reason: 'b is not selected, must not rebuild');

    viewModel.incrementA();
    await tester.pump(Duration.zero);
    expect(builds, 2);
    expect(find.text('a=1'), findsOneWidget);
  });
}
