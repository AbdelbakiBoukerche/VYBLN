import '../models/username.dart';

extension UsernameValidationErrorText on UsernameValidationError {
  String text() {
    switch (this) {
      case UsernameValidationError.empty:
        return 'Username cannot be left empty';
      case UsernameValidationError.invalid:
        return 'Please ensure the username entered is valid';
    }
  }
}
