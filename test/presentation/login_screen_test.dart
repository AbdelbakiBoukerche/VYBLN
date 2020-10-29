import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/logic/authentication/authentication.dart';
import 'package:vybln/logic/login/login_cubit.dart';
import 'package:vybln/presentation/screens/login_screen.dart';
import 'package:vybln/presentation/screens/signup_screen.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLoginCubit extends MockBloc<LoginState> implements LoginCubit {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements Password {}

void main() {
  // Test The LoginScreen
  group('LoginScreen', () {
    test('Has a route', () {
      expect(LoginScreen.route(), isA<MaterialPageRoute>());
    });

    testWidgets('Renders a LoginForm', (tester) async {
      await tester.pumpWidget(RepositoryProvider<AuthenticationRepository>(
        create: (_) => MockAuthenticationRepository(),
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ));
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });

  // Test The LoginForm
  const loginButtonKey = Key('loginForm_login_flatButton');
  const emailInputKey = Key('loginForm_email_textField');
  const passwordInputKey = Key('loginForm_password_textField');
  const createAccountButtonKey = Key('loginForm_signup_flatButton');
  const testEmail = 'test@gmail.com';
  const testPassword = 'passwd1234';
  group('LoginForm', () {
    LoginCubit loginCubit;

    setUp(() {
      loginCubit = MockLoginCubit();
      when(loginCubit.state).thenReturn(const LoginState());
    });

    group('Calls', () {
      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(loginCubit.emailChanged(testEmail)).called(1);
      });

      testWidgets('passwordChanged when password changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(loginCubit.passwordChanged(testPassword)).called(1);
      });

      testWidgets('logInWithCredentials when login button is pressed',
          (tester) async {
        when(loginCubit.state).thenReturn(
          const LoginState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(loginButtonKey));
        verify(loginCubit.logInWithCredentials()).called(1);
      });
    });

    group('Renders', () {
      testWidgets('AuthFailure SnackBar when submissin fails', (tester) async {
        whenListen(
          loginCubit,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzStatus.submissionInProgress),
            LoginState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Authentication Failed'), findsOneWidget);
      });

      testWidgets('Invalid email error when email is invalid', (tester) async {
        final email = MockEmail();
        when(email.invalid).thenReturn(true);
        when(loginCubit.state).thenReturn(LoginState(email: email));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        expect(find.text('Invalid Email'), findsOneWidget);
      });

      testWidgets('Invalid password error when password is invalid',
          (tester) async {
        final password = MockPassword();
        when(password.invalid).thenReturn(true);
        when(loginCubit.state).thenReturn(LoginState(password: password));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        expect(find.text('Invalid Password'), findsOneWidget);
      });

      testWidgets('Disable login button when status is not validated',
          (tester) async {
        when(loginCubit.state)
            .thenReturn(const LoginState(status: FormzStatus.invalid));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        final loginButton = tester.widget<RaisedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isFalse);
      });

      testWidgets('Enable login button when status is validated',
          (tester) async {
        when(loginCubit.state)
            .thenReturn(const LoginState(status: FormzStatus.valid));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: LoginForm(),
              ),
            ),
          ),
        );
        final loginButton = tester.widget<RaisedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isTrue);
      });
    });
    group('Navigates', () {
      testWidgets('to SignUp when create account is pressed', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthenticationRepository>(
            create: (_) => MockAuthenticationRepository(),
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: loginCubit,
                  child: LoginForm(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(createAccountButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(SignUpScreen), findsOneWidget);
      });
    });
  });
}
