import 'package:formz/formz.dart';

enum UsernameValidationError { empty, invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  static final RegExp _regExp = RegExp(
    r'^[a-zA-Z_](?!.*?\.{2})[\w.]{1,28}[\w]$',
  );

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    }
    if (!_regExp.hasMatch(value)) {
      return UsernameValidationError.invalid;
    }
    return null;
  }
}
