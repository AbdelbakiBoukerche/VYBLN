import 'dart:async';
import 'package:meta/meta.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<VyblnUser> _userSubscription;

  AuthBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthState.unkown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthUserChanged) {
      yield _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      _authenticationRepository.logOut();
      yield AuthState.unauthenticated();
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthState _mapAuthUserChangedToState(AuthUserChanged event) {
    return event.user != VyblnUser.empty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated();
  }
}
