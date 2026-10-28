import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';
import 'package:lubase/view/features/login/login_view_model.dart';

import '../../../helpers/fakes.dart';

void main() {
  tearDown(getIt.reset);

  test('isValidButton is true only when email and password are valid', () {
    final viewModel = LoginViewModel();

    expect(viewModel.state.isValidButton, isFalse);

    viewModel.onEmailChanged('user@example.com');
    expect(viewModel.state.isValidButton, isFalse);

    viewModel.onPasswordChanged('12345678');
    expect(viewModel.state.isValidButton, isTrue);
  });

  test('onChangeThemeMode updates ThemeCubit', () {
    Dependence.register(FakeRepository());
    LoginViewModel().onChangeThemeMode(Brightness.dark);
    expect(getIt<ThemeCubit>().state, Brightness.dark);
  });

  test(
    'onPressLogin sends the form values and rethrows repository errors',
    () async {
      final auth = FakeAuthRepository();
      Dependence.register(FakeRepository(auth: auth));
      final viewModel = LoginViewModel()
        ..onEmailChanged('user@example.com')
        ..onPasswordChanged('12345678');

      await viewModel.onPressLogin();
      expect(auth.requests, hasLength(1));
      expect(auth.requests.single.email, 'user@example.com');
      expect(auth.requests.single.password, '12345678');

      auth.onLogin = (_) async => throw Exception('401');
      await expectLater(viewModel.onPressLogin(), throwsException);
    },
  );
}
