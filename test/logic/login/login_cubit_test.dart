import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/logic/authentication/authentication.dart';
import 'package:vybln/logic/login/login_cubit.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'pass';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 'password1234';
  const validPassword = Password.dirty(validPasswordString);

  group('LoginCubit', () {
    AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    test('Throws AssertionError when authRespository is null', () {
      expect(() => LoginCubit(null), throwsA(isA<AssertionError>()));
    });

    test('Initial state is LoginState', () {
      expect(LoginCubit(authenticationRepository).state, LoginState());
    });

    group('EmailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: const <LoginState>[
          LoginState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authenticationRepository)
          ..emit(LoginState(password: validPassword)),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: const <LoginState>[
          LoginState(
              email: validEmail,
              password: validPassword,
              status: FormzStatus.valid),
        ],
      );
    });

    group('PasswordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: const <LoginState>[
          LoginState(
            password: invalidPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authenticationRepository)
          ..emit(LoginState(email: validEmail)),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('loginWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: const <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'calls logIn with correct email/password',
        build: () => LoginCubit(authenticationRepository)
          ..emit(LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          )),
        act: (cubit) => cubit.logInWithCredentials(),
        verify: (_) {
          verify(
            authenticationRepository.logIn(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess '
        'when logIn succeeds',
        build: () => LoginCubit(authenticationRepository)
          ..emit(LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          )),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
            password: validPassword,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logIn fails',
        build: () {
          when(authenticationRepository.logIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).thenThrow(Exception('fails'));
          return LoginCubit(authenticationRepository)
            ..emit(
              LoginState(
                status: FormzStatus.valid,
                email: validEmail,
                password: validPassword,
              ),
            );
        },
        act: (cubit) => cubit.logInWithCredentials(),
        expect: const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
          ),
        ],
      );
    });
  });
}
