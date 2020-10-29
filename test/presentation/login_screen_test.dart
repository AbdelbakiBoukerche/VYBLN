import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vybln/presentation/screens/login_screen.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

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
  group('LoginForm', () {});
}
