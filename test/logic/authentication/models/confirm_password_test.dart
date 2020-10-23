import 'package:flutter_test/flutter_test.dart';
import 'package:vybln/logic/authentication/authentication.dart';

void main() {
  const confirmedPasswordString = "password123456";
  const passwordString = "password123456";
  const password = Password.dirty(passwordString);

  group('Confirmed password', () {
    group('Constructors', () {
      test('Pure creates correct instance', () {
        final confirmedPassword = ConfirmPassword.pure();
        expect(confirmedPassword.value, '');
        expect(confirmedPassword.pure, true);
      });

      test('Dirty creates correct instance', () {
        final confirmedPassword = ConfirmPassword.dirty(
            password: password.value, value: confirmedPasswordString);
        expect(confirmedPassword.value, confirmedPasswordString);
        expect(confirmedPassword.password, password.value);
        expect(confirmedPassword.pure, false);
      });
    });
    group('Validators', () {
      test('Returns invalid error when confirmed password is empty', () {
        expect(ConfirmPassword.dirty(password: password.value, value: '').error,
            ConfirmedPasswordValidationError.invalid);
      });
      test('is valid when confirmedPassword is not empty', () {
        expect(
          ConfirmPassword.dirty(
            password: password.value,
            value: confirmedPasswordString,
          ).error,
          isNull,
        );
      });
    });
  });
}
