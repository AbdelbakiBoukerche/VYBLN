import '../models/password.dart';

extension PasswordValidationErrorText on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Password cannot be left empty';
      case PasswordValidationError.invalid:
        return 'Password must be at least 8 characters long';
    }
  }
}
