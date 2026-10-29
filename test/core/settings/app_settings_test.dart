import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';

void main() {
  group('LocaleCubit', () {
    test('defaults to English and switches to a supported locale', () {
      final locale = LocaleCubit();
      expect(locale.state, SupportLocale.en);

      locale.setLocale(SupportLocale.vn);
      expect(locale.state, SupportLocale.vn);

      locale.clearLocale();
      expect(locale.state, SupportLocale.en);
    });

    test('ignores unsupported locales', () {
      final locale = LocaleCubit()..setLocale(const Locale('ja'));
      expect(locale.state, SupportLocale.en);
    });
  });

  test('ThemeCubit defaults to light, can switch and reset', () {
    final theme = ThemeCubit();
    expect(theme.state, Brightness.light);

    theme.setBrightness(Brightness.dark);
    expect(theme.state, Brightness.dark);

    theme.clearBrightness();
    expect(theme.state, Brightness.light);
  });
}
