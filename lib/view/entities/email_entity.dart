import 'package:freezed_annotation/freezed_annotation.dart';

import '../../resources/generated/l10n.dart';
import '../../utils/regex_constants.dart';

part 'email_entity.freezed.dart';

@freezed
sealed class EmailEntity with _$EmailEntity {
  const factory EmailEntity(String? value) = _EmailEntity;

  const EmailEntity._();

  factory EmailEntity.create(String value) => EmailEntity(value);

  factory EmailEntity.pure() => const EmailEntity(null);

  bool get valid => _isEmail();

  String? errorText() {
    if (_isEmail()) {
      return null;
    } else if (value == null) {
      return null;
    } else if (value?.isEmpty ?? false) {
      return S.current.email_required;
    } else {
      return S.current.email_invalid;
    }
  }

  bool _isEmail() => RegExp(RegexConstants.email).hasMatch(value ?? '');
}
