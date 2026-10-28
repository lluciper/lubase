import 'package:freezed_annotation/freezed_annotation.dart';

import '../../resources/generated/l10n.dart';
import '../../utils/extensions/extensions.dart';

part 'password_entity.freezed.dart';

@freezed
sealed class PasswordEntity with _$PasswordEntity {
  const factory PasswordEntity(String? value) = _PasswordEntity;

  const PasswordEntity._();

  factory PasswordEntity.create(String value) => PasswordEntity(value);

  factory PasswordEntity.pure() => const PasswordEntity(null);

  bool get valid => _isPassword();

  String? errorText() {
    if (value == null || _isPassword()) {
      return null;
    } else if (value.isNullOrEmpty) {
      return S.current.password_required;
    } else {
      return S.current.password_invalid;
    }
  }

  bool _isPassword() => (value ?? '').length >= 8;
}
