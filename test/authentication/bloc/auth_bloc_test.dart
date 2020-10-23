import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/logic/authentication/authentication.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

// ignore: must_be_immutable
class MockVyblnUser extends Mock implements VyblnUser {}

void main() {
  final user = MockVyblnUser();
  AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    when(authenticationRepository.user).thenAnswer((_) => const Stream.empty());
  });

  group('AuthBloc', () {
    test('Throws when authenticationRepository is null', () {
      expect(
          () => AuthBloc(authenticationRepository: null), throwsAssertionError);
    });

    test('Initial state is AuthState.unkown', () {
      final authBloc =
          AuthBloc(authenticationRepository: authenticationRepository);
      expect(authBloc.state, const AuthState.unkown());
      authBloc.close();
    });

    blocTest<AuthBloc, AuthState>('Subscription to user stream', build: () {
      when(authenticationRepository.user).thenAnswer(
        (_) => Stream.value(user),
      );
      return AuthBloc(
        authenticationRepository: authenticationRepository,
      );
    }, expect: <AuthState>[
      AuthState.authenticated(user),
    ]);

    group('AuthenticationUserChanged', () {
      blocTest<AuthBloc, AuthState>(
        'Emits [authenticated] when user is not null',
        build: () =>
            AuthBloc(authenticationRepository: authenticationRepository),
        act: (bloc) => bloc.add(AuthUserChanged(user)),
        expect: <AuthState>[AuthState.authenticated(user)],
      );
      blocTest<AuthBloc, AuthState>(
        'Emits [unauthenticated] when user is empty',
        build: () =>
            AuthBloc(authenticationRepository: authenticationRepository),
        act: (bloc) => bloc.add(
          const AuthUserChanged(VyblnUser.empty),
        ),
        expect: const <AuthState>[AuthState.unauthenticated()],
      );
    });

    group('AuthLogouRequested', () {
      blocTest<AuthBloc, AuthState>('calls logOut on authenticationRepository',
          build: () =>
              AuthBloc(authenticationRepository: authenticationRepository),
          act: (bloc) => bloc.add(AuthLogoutRequested()),
          verify: (_) {
            verify(authenticationRepository.logOut()).called(1);
          });
    });
  });
}
