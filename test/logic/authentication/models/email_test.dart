import 'package:flutter_test/flutter_test.dart';
import 'package:vybln/logic/authentication/authentication.dart';

void main() {
  const emailString = 'baki@gmail.com';

  group('Email', () {
    group('Constructos', () {
      test('Pure creates correct instance', () {
        final email = Email.pure();
        expect(email.value, '');
        expect(email.pure, true);
      });

      test('Dirty creates correct instance', () {
        final email = Email.dirty(emailString);
        expect(email.value, emailString);
        expect(email.pure, false);
      });
    });

    group('Validators', () {
      test('Returns invalid error when email is empty', () {
        expect(Email.dirty('').error, EmailValidationError.invalid);
      });

      test('Returns invalid error when email is malformed', () {
        expect(Email.dirty('baki').error, EmailValidationError.invalid);
      });

      test('Is valid when email is valid', () {
        expect(Email.dirty(emailString).error, isNull);
      });
    });
  });
}
