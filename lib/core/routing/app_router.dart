import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/blocs/auth/auth_bloc.dart';
import '../../features/auth/screens/signin_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/chat/screens/chats_screen.dart';
import '../../features/chat/screens/messaging_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/peer_profile_screen.dart';
import '../injection_container.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter get sRouter => _router;

  static String get sSigninPath => SigninScreen.sPath;
  static String get sSignupPath => SignupScreen.sPath;
  static String get sHomePath => HomeScreen.sPath;
  static String get sEditProfilePath => EditProfileScreen.sPath;
  static String get sPeerProfilePath => PeerProfileScreen.sPath;
  static String get sChatsPath => ChatsScreen.sPath;
  static String get sMessagingPath => MessagingScreen.sPath;

  static Page<MaterialPage<void>> _messagingPageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: MessagingScreen());

  static Page<MaterialPage<void>> _chatsPageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: ChatsScreen());

  static Page<MaterialPage<void>> _peerProfilePageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: PeerProfileScreen());

  static Page<MaterialPage<void>> _editProfilePageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: EditProfileScreen());

  static Page<MaterialPage<void>> _homePageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: HomeScreen());

  static Page<MaterialPage<void>> _signinPageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: SigninScreen());

  static Page<MaterialPage<void>> _signupPageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) =>
      const MaterialPage(child: SignupScreen());

  static Page<MaterialPage<void>> _errorPageBuilder(
    BuildContext ctx,
    GoRouterState state,
  ) {
    return const MaterialPage(child: Scaffold());
  }

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: sSigninPath,
    refreshListenable: _GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: (context, state) {
      final bloc = sl<AuthBloc>();
      final isOnSignIn = state.location == sSigninPath;
      final isOnSignUp = state.location == sSignupPath;
      bool isSignedIn = false;
      if (bloc.state is AuthUserAuthenticated) {
        isSignedIn = (bloc.state as AuthUserAuthenticated).mUser.isNotEmpty;
      }

      if (!isOnSignIn && !isOnSignUp && !isSignedIn) {
        return sSigninPath;
      }
      if ((isOnSignIn || isOnSignUp) && isSignedIn) {
        return sHomePath;
      }
      return null;
    },
    routes: [
      // Authentication
      GoRoute(path: sSigninPath, pageBuilder: _signinPageBuilder),
      GoRoute(path: sSignupPath, pageBuilder: _signupPageBuilder),

      // Home
      GoRoute(path: sHomePath, pageBuilder: _homePageBuilder),

      // Profile
      GoRoute(path: sEditProfilePath, pageBuilder: _editProfilePageBuilder),
      GoRoute(path: sPeerProfilePath, pageBuilder: _peerProfilePageBuilder),

      // Chat
      GoRoute(path: sChatsPath, pageBuilder: _chatsPageBuilder),
      GoRoute(path: sMessagingPath, pageBuilder: _messagingPageBuilder),
    ],
    errorPageBuilder: _errorPageBuilder,
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
