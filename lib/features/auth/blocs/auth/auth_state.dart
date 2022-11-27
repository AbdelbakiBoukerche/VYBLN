part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthUserAuthenticated extends AuthState {
  const AuthUserAuthenticated(User user) : mUser = user;

  final User mUser;

  @override
  List<Object> get props => [mUser];
}

class AuthUserUnauthenticated extends AuthState {}
