import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/utils/index.dart';

void main() {
  group('String extensions', () {
    test('isNullOrEmpty / isNotNullOrEmpty', () {
      const String? nullString = null;
      expect(nullString.isNullOrEmpty, isTrue);
      expect(''.isNullOrEmpty, isTrue);
      expect('a'.isNullOrEmpty, isFalse);

      expect(nullString.isNotNullOrEmpty, isFalse);
      expect(''.isNotNullOrEmpty, isFalse);
      expect('a'.isNotNullOrEmpty, isTrue);
    });

    test('isNullOrBlank / isNotNullOrBlank', () {
      const String? nullString = null;
      expect(nullString.isNullOrBlank, isTrue);
      expect('   '.isNullOrBlank, isTrue);
      expect(' a '.isNullOrBlank, isFalse);

      expect('   '.isNotNullOrBlank, isFalse);
      expect('null'.isNotNullOrBlank, isFalse);
      expect('a'.isNotNullOrBlank, isTrue);
    });
  });
}
