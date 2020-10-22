import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Tests', () {
    const id = 'mock-id';
    const email = 'mock-email';
    test('Throw AssertionnError when email is NULL', () {
      expect(
        () => VyblnUser(email: null, id: id, name: null, photo: null),
        throwsAssertionError,
      );
    });

    test('Throw AssertionError when id is null', () {
      expect(
        () => VyblnUser(email: email, id: null, name: null, photo: null),
        throwsAssertionError,
      );
    });

    test('Uses value equality', () {
      expect(
        VyblnUser(email: email, id: id, name: null, photo: null),
        VyblnUser(email: email, id: id, name: null, photo: null),
      );
    });
  });
}
