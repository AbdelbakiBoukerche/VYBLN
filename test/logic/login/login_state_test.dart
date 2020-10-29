import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:vybln/logic/authentication/authentication.dart';
import 'package:vybln/logic/login/login_cubit.dart';

void main() {
  const email = Email.dirty('email');
  const password = Password.dirty('password');

  group('LoginState', () {
    test('Supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('Return Same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('Return object with updated status when status is passed', () {
      expect(LoginState().copyWith(status: FormzStatus.pure),
          LoginState(status: FormzStatus.pure));
    });

    test('Return object with updated email when email is passed', () {
      expect(LoginState().copyWith(email: email), LoginState(email: email));
    });

    test('Return object with updated password when password is passed', () {
      expect(LoginState().copyWith(password: password),
          LoginState(password: password));
    });
  });
}
