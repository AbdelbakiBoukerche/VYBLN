part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChanged extends AuthEvent {
  const AuthStateChanged(User user) : mUser = user;

  final User mUser;
}

class AuthSignOutRequested extends AuthEvent {}
