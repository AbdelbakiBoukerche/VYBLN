import '../models/full_name.dart';

extension FullnameValidationErrorText on FullnameValidationError {
  String text() {
    switch (this) {
      case FullnameValidationError.empty:
        return 'Fullname cannot be left empty';
      case FullnameValidationError.invalid:
        return 'Fullname must be at least 4 characters long';
    }
  }
}
