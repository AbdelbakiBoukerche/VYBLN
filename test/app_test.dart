import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/app.dart';
import 'package:vybln/logic/authentication/authentication.dart';

class MockUser extends Mock implements VyblnUser {
  @override
  String get id => 'id';

  @override
  String get name => 'Baki';

  @override
  String get email => 'Baki@gmail.com';
}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('App', () {
    AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(authenticationRepository.user)
          .thenAnswer((_) => const Stream.empty());
    });

    test('Throws AssertionError when authRepository is null', () {
      expect(() => Vybln(authenticationRepository: null), throwsAssertionError);
    });
  });
}
