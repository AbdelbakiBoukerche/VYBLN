import 'package:formz/formz.dart';

enum FullnameValidationError { empty, invalid }

class Fullname extends FormzInput<String, FullnameValidationError> {
  const Fullname.pure() : super.pure('');
  const Fullname.dirty([String value = '']) : super.dirty(value);

  @override
  FullnameValidationError? validator(String value) {
    if (value.isEmpty) {
      return FullnameValidationError.empty;
    }
    if (value.length < 4) {
      return FullnameValidationError.invalid;
    }
    return null;
  }
}
