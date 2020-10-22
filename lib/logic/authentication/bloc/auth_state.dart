part of 'auth_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unkown }

class AuthState extends Equatable {
  final AuthenticationStatus status;
  final VyblnUser user;

  const AuthState._({
    this.status = AuthenticationStatus.unkown,
    this.user = VyblnUser.empty,
  });

  const AuthState.unkown() : this._();

  const AuthState.authenticated(VyblnUser user)
      : this._(user: user, status: AuthenticationStatus.authenticated);

  const AuthState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
