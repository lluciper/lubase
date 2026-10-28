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

  group('RefreshService', () {
    setUp(RefreshService.clear);

    test(
      'hadRefresh is true only for initialized pages marked for refresh',
      () {
        RefreshService.addPage('HomePage');
        expect(RefreshService.hadRefresh('HomePage'), isFalse);

        RefreshService.addPageInitialized('HomePage');
        expect(RefreshService.hadRefresh('HomePage'), isTrue);

        RefreshService.removePage('HomePage');
        expect(RefreshService.hadRefresh('HomePage'), isFalse);
        RefreshService.removePageInitialized('HomePage');
      },
    );

    test('accepts Type, String and lists of them', () {
      RefreshService.addPageInitialized('int');
      RefreshService.addPageInitialized('A');
      RefreshService.addPageInitialized('B');
      RefreshService.addPage(int);
      RefreshService.addPage(['A', 'B']);
      expect(RefreshService.hadRefresh('int'), isTrue);
      expect(RefreshService.hadRefresh('A'), isTrue);

      RefreshService.removePage([int]);
      expect(RefreshService.hadRefresh('int'), isFalse);
    });

    test('throws on unsupported argument types', () {
      expect(() => RefreshService.addPage(1), throwsException);
      expect(() => RefreshService.removePage(1), throwsException);
    });
  });
}
