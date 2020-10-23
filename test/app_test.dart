import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/app.dart';
import 'package:vybln/logic/authentication/authentication.dart';
import 'package:vybln/presentation/screens/home_screen.dart';
import 'package:vybln/presentation/screens/login_screen.dart';
import 'package:vybln/presentation/screens/splash_screen.dart';

// ignore: must_be_immutable
class MockVyblnUser extends Mock implements VyblnUser {
  @override
  String get id => 'id';

  @override
  String get name => 'Baki';

  @override
  String get email => 'baki@gmail.com';
}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('Vybln', () {
    AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(authenticationRepository.user)
          .thenAnswer((_) => const Stream.empty());
    });

    test('Throws AssertionError when authRepository is null', () {
      expect(() => Vybln(authenticationRepository: null), throwsAssertionError);
    });

    testWidgets('Renders AppView', (tester) async {
      await tester.pumpWidget(
          Vybln(authenticationRepository: authenticationRepository));
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    AuthBloc authBloc;
    AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authBloc = MockAuthBloc();
    });

    testWidgets('Renders Splash Screen by default', (tester) async {
      await tester.pumpWidget(BlocProvider.value(
        value: authBloc,
        child: AppView(),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('Navigates to Login Screen when status is unauthenticated',
        (tester) async {
      whenListen(
        authBloc,
        Stream.value(const AuthState.unauthenticated()),
      );
      await tester.pumpWidget(RepositoryProvider.value(
        value: authenticationRepository,
        child: BlocProvider.value(
          value: authBloc,
          child: AppView(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Navigates to Home Screen when status is authenticated',
        (tester) async {
      whenListen(
        authBloc,
        Stream.value(AuthState.authenticated(MockVyblnUser())),
      );
      await tester.pumpWidget(RepositoryProvider.value(
        value: authenticationRepository,
        child: BlocProvider.value(
          value: authBloc,
          child: AppView(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
