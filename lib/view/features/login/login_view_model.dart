import 'dart:ui';

import '../../../core/index.dart';
import '../../../data/index.dart';
import '../../entities/email_entity.dart';
import '../../entities/password_entity.dart';
import 'login_state.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel() : super(LoginState.initial());

  void onEmailChanged(String value) {
    emit(state.copyWith(email: EmailEntity.create(value)));
    _checkValidButton();
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: PasswordEntity.create(value)));
    _checkValidButton();
  }

  void _checkValidButton() {
    emit(
      state.copyWith(isValidButton: state.email.valid && state.password.valid),
    );
  }

  void onChangeThemeMode(Brightness mode) {
    getIt<ThemeCubit>().setBrightness(mode);
  }

  void onChangeLanguage(Locale lang) {
    getIt<LocaleCubit>().setLocale(lang);
  }

  Future<LoginResponseModel> onPressLogin() => repository.auth.login(
    LoginRequestModel(
      email: state.email.value ?? '',
      password: state.password.value ?? '',
    ),
  );
}
