import 'package:flutter_test/flutter_test.dart';
import 'package:vybln/logic/authentication/authentication.dart';

void main() {
  group('AuthEvent', () {
    test('Supports value comparisons', () {
      expect(AuthLogoutRequested(), AuthLogoutRequested());
    });

    test('AuthUserChanged supports value comparisons', () {
      expect(AuthUserChanged(null), AuthUserChanged(null));
    });
  });
}
