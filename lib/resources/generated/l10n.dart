// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to our app!`
  String get welcome {
    return Intl.message(
      'Welcome to our app!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home_title {
    return Intl.message('Home', name: 'home_title', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Open detail`
  String get home_open_detail {
    return Intl.message(
      'Open detail',
      name: 'home_open_detail',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail_title {
    return Intl.message('Detail', name: 'detail_title', desc: '', args: []);
  }

  /// `Param: {id}`
  String detail_param(Object id) {
    return Intl.message(
      'Param: $id',
      name: 'detail_param',
      desc: '',
      args: [id],
    );
  }

  /// `No param`
  String get detail_no_param {
    return Intl.message(
      'No param',
      name: 'detail_no_param',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel_button_dialog {
    return Intl.message(
      'CANCEL',
      name: 'cancel_button_dialog',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok_button_dialog {
    return Intl.message('OK', name: 'ok_button_dialog', desc: '', args: []);
  }

  /// `Login`
  String get login_button {
    return Intl.message('Login', name: 'login_button', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter your email address`
  String get enter_email {
    return Intl.message(
      'Enter your email address',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Email is required.`
  String get email_required {
    return Intl.message(
      'Email is required.',
      name: 'email_required',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get email_invalid {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your password`
  String get enter_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Password is required.`
  String get password_required {
    return Intl.message(
      'Password is required.',
      name: 'password_required',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid password.`
  String get password_invalid {
    return Intl.message(
      'Please enter a valid password.',
      name: 'password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Please check your connection and try again.`
  String get network_error {
    return Intl.message(
      'Network error. Please check your connection and try again.',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get server_error {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'server_error',
      desc: '',
      args: [],
    );
  }

  /// `Request timed out. Please try again later.`
  String get timeout_error {
    return Intl.message(
      'Request timed out. Please try again later.',
      name: 'timeout_error',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get language_english {
    return Intl.message(
      'English',
      name: 'language_english',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get language_vietnam {
    return Intl.message(
      'Vietnamese',
      name: 'language_vietnam',
      desc: '',
      args: [],
    );
  }

  /// `Theme mode`
  String get theme_mode {
    return Intl.message('Theme mode', name: 'theme_mode', desc: '', args: []);
  }

  /// `Dark`
  String get dark_mode {
    return Intl.message('Dark', name: 'dark_mode', desc: '', args: []);
  }

  /// `Light`
  String get light_mode {
    return Intl.message('Light', name: 'light_mode', desc: '', args: []);
  }

  /// `An unknown error occurred. Please try again later.`
  String get unknown_error {
    return Intl.message(
      'An unknown error occurred. Please try again later.',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
