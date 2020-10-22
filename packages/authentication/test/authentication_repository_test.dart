import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const _mockFirebaseUserUid = 'mock-id';
const _mockFirebaseUserEmail = 'mock-email';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {
  @override
  String get uid => _mockFirebaseUserUid;

  @override
  String get email => _mockFirebaseUserEmail;
}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannel("Firebase").setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': const <String, String>{},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return <String, dynamic>{
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': const <String, String>{},
      };
    }

    return null;
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  const email = 'test@gmail.com';
  const password = 'helloworld!';
  const user = VyblnUser(
    email: _mockFirebaseUserEmail,
    id: _mockFirebaseUserUid,
    name: null,
    photo: null,
  );

  group('Authentication Repository', () {
    FirebaseAuth firebaseAuth;
    AuthenticationRepository authenticationRepository;

    setUp(() {
      firebaseAuth = MockFirebaseAuth();
      authenticationRepository =
          AuthenticationRepository(firebaseAuth: firebaseAuth);
    });

    test('Creates FirebaseAuth Instance internally when not injected', () {
      expect(() => AuthenticationRepository(), isNot(throwsException));
    });

    group('SignUp', () {
      test('Throws AssertionError when email is null', () {
        expect(
          () =>
              authenticationRepository.signUp(email: null, password: password),
          throwsAssertionError,
        );
      });

      test('Throws AssertionError when password is null', () {
        expect(
          () => authenticationRepository.signUp(email: email, password: null),
          throwsAssertionError,
        );
      });

      test('Calls createUserWithEmailAndPassword', () async {
        await authenticationRepository.signUp(email: email, password: password);
        verify(firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });

      test('Succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.signUp(email: email, password: password),
          completes,
        );
      });

      test("Throws SignUpFailure when createUserWithEmailAndPassword throws",
          () async {
        when(firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(Exception());
        expect(
          authenticationRepository.signUp(email: email, password: password),
          throwsA(isA<SignUpFailure>()),
        );
      });
    });

    group('logIn', () {
      test('Throws AssertionError when email is null', () {
        expect(
            () =>
                authenticationRepository.logIn(email: null, password: password),
            throwsAssertionError);
      });

      test('Throws AssertionError when password is null', () {
        expect(
          () => authenticationRepository.logIn(email: email, password: null),
          throwsAssertionError,
        );
      });

      test('Calls signInWithEmailAndPassword', () async {
        await authenticationRepository.logIn(email: email, password: password);
        verify(firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .called(1);
      });

      test('Succeeds when signInWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.logIn(email: email, password: password),
          completes,
        );
      });

      test(
          'Throws LoginWithEmailAndPaswordFailure when signInWithEmailAndPassword throws',
          () async {
        when(firebaseAuth.signInWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(Exception());
        expect(
          authenticationRepository.logIn(email: email, password: password),
          throwsA(isA<LoginWithEmailAndPasswordFailure>()),
        );
      });
    });

    group('logOut', () {
      test('Calls signOut', () async {
        when(firebaseAuth.signOut()).thenAnswer((_) => null);
        await authenticationRepository.logOut();
        verify(firebaseAuth.signOut()).called(1);
      });

      test('Throws LogOutFailure when signOut throws', () {
        when(firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          authenticationRepository.logOut(),
          throwsA(isA<LogOutFailure>()),
        );
      });
    });

    group('User', () {
      test('Emit VyblnUser.empty when firebase user is null', () async {
        when(firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));
        await expectLater(authenticationRepository.user,
            emitsInOrder(const <VyblnUser>[VyblnUser.empty]));
      });

      test('Emit VyblnUser when firebase user is not null', () async {
        when(firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(MockFirebaseUser()));
        await expectLater(authenticationRepository.user,
            emitsInOrder(const <VyblnUser>[user]));
      });
    });
  });
}
