import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/logic/authentication/authentication.dart';

// ignore: must_be_immutable
class MockVyblnUser extends Mock implements VyblnUser {}

void main() {
  group('AuthState', () {
    test('[AuthState.unkown] support value comparisons', () {
      expect(AuthState.unkown(), AuthState.unkown());
    });

    test('[AuthState.authenticated] support value comparisons', () {
      final user = MockVyblnUser();
      expect(AuthState.authenticated(user), AuthState.authenticated(user));
    });

    test('[AuthState.unauthenticated] support value comparisons', () {
      expect(AuthState.unauthenticated(), AuthState.unauthenticated());
    });
  });
}
