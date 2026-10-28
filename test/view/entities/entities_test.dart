import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubase/resources/generated/l10n.dart';
import 'package:lubase/view/entities/email_entity.dart';
import 'package:lubase/view/entities/password_entity.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

  group('EmailEntity', () {
    test('pure() has no error and is not valid', () {
      final email = EmailEntity.pure();
      expect(email.valid, isFalse);
      expect(email.errorText(), isNull);
    });

    test('empty value -> required error', () {
      expect(EmailEntity.create('').errorText(), S.current.email_required);
    });

    test('invalid value -> invalid error', () {
      final email = EmailEntity.create('not-an-email');
      expect(email.valid, isFalse);
      expect(email.errorText(), S.current.email_invalid);
    });

    test('valid value -> no error', () {
      final email = EmailEntity.create('user@example.com');
      expect(email.valid, isTrue);
      expect(email.errorText(), isNull);
    });
  });

  group('PasswordEntity', () {
    test('pure() has no error and is not valid', () {
      final password = PasswordEntity.pure();
      expect(password.valid, isFalse);
      expect(password.errorText(), isNull);
    });

    test('empty value -> required error', () {
      expect(
        PasswordEntity.create('').errorText(),
        S.current.password_required,
      );
    });

    test('shorter than 8 chars -> invalid error', () {
      expect(
        PasswordEntity.create('1234567').errorText(),
        S.current.password_invalid,
      );
    });

    test('8+ chars -> valid', () {
      final password = PasswordEntity.create('12345678');
      expect(password.valid, isTrue);
      expect(password.errorText(), isNull);
    });
  });
}
