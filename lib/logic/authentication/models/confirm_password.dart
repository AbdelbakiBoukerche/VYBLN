import 'package:formz/formz.dart';

import 'package:meta/meta.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({@required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordValidationError validator(String value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}
