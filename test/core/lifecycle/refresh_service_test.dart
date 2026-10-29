import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/core/index.dart';

void main() {
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
