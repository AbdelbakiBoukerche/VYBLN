import 'package:flutter_test/flutter_test.dart';
import 'package:vybln/logic/authentication/authentication.dart';

void main() {
  const passwordString = "password123456";

  group('Password', () {
    group('Constructors', () {
      test('Pure creates correct instance', () {
        final password = Password.pure();
        expect(password.value, '');
        expect(password.pure, true);
      });

      test('Dirty creates correct instance', () {
        final password = Password.dirty(passwordString);
        expect(password.value, passwordString);
        expect(password.pure, false);
      });
    });

    group('Validators', () {
      test('Returns invalid if password is empty', () {
        expect(Password.dirty('').error, PasswordValidationError.invalid);
      });
    });

    test('Is valid when password is not empty', () {
      expect(Password.dirty(passwordString).error, isNull);
    });
  });
}
