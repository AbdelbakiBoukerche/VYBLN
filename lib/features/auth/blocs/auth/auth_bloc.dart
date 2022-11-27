import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/user.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthUserUnauthenticated()) {
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthSignOutRequested>(_onSignOutRequested);

    _streamSubscription = _authRepository.user.listen(
      (event) => add(AuthStateChanged(event)),
    );
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.mUser.isEmpty) {
      emit(AuthUserUnauthenticated());
    } else {
      emit(AuthUserAuthenticated(event.mUser));
    }
  }

  void _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_authRepository.signOut());
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();

    return super.close();
  }

  final AuthRepository _authRepository;
  late StreamSubscription<User> _streamSubscription;
}
