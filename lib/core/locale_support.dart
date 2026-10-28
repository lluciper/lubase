import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources/generated/l10n.dart';

/// The app language, in `getIt`; `App` rebuilds when it changes.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(SupportLocale.en);

  void setLocale(Locale locale) {
    if (!SupportLocale.support.contains(locale)) {
      return;
    }
    emit(locale);
  }

  void clearLocale() {
    emit(SupportLocale.en);
  }
}

class SupportLocale {
  static const Locale en = Locale('en');
  static const Locale vn = Locale('vi');

  /// The ARB files are the single source: adding `intl_xx.arb` adds a locale.
  static List<Locale> get support => S.delegate.supportedLocales;
}
