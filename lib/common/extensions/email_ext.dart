import '../models/email.dart';

extension EmailValidationErrorText on EmailValidationError {
  String text() {
    switch (this) {
      case EmailValidationError.empty:
        return 'Email cannot be left empty';
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
    }
  }
}
