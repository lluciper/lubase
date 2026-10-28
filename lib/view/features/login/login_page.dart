import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../../../core/index.dart';
import '../../../resources/generated/assets.gen.dart';
import '../../../resources/generated/l10n.dart';
import '../../../resources/resources.dart';
import 'login_view_model.dart';
import 'widgets/login_panel.dart';

class LoginPage extends BasePage {
  const LoginPage({this.from, super.key});

  /// The screen to open after login (see LoginRoute.from).
  final String? from;

  @override
  BasePageState<LoginPage, LoginViewModel> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage, LoginViewModel> {
  @override
  LoginViewModel createViewModel() => LoginViewModel();

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 64),
          Assets.imageFlutter.image(),
          const SizedBox(height: 16),
          LoginPanel(viewModel: viewModel, onPressLogin: onPressLogin),
          const SizedBox(height: 16),
          Text(
            S.current.language,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                child: Text(S.current.language_english),
                onPressed: () => viewModel.onChangeLanguage(SupportLocale.en),
              ),
              ElevatedButton(
                child: Text(S.current.language_vietnam),
                onPressed: () => viewModel.onChangeLanguage(SupportLocale.vn),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            S.current.theme_mode,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                child: Text(S.current.dark_mode),
                onPressed: () => viewModel.onChangeThemeMode(Brightness.dark),
              ),

              ElevatedButton(
                child: Text(S.current.light_mode),
                onPressed: () => viewModel.onChangeThemeMode(Brightness.light),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  /// `from` comes from a URL: only follow in-app paths, otherwise Home.
  String get _nextLocation {
    final from = widget.from;
    return from != null && from.startsWith('/') && !from.startsWith('//')
        ? from
        : const HomeRoute().location;
  }

  void onPressLogin() {
    viewModel
        .onPressLogin()
        .subscribeLoadingFullScreen(this)
        .subscribeOnSuccess(this, success: (_) => context.go(_nextLocation))
        .subscribeHandleError(this);
  }
}
