import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../common/models/email.dart';
import '../../../../common/models/password.dart';
import '../../../../core/exceptions/auth_exceptions.dart';

import '../../repositories/auth_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SigninState()) {
    on<SigninEmailChanged>(_onEmailChanged);
    on<SigninPasswordChanged>(_onPasswordChnaged);
    on<SigninSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    SigninEmailChanged event,
    Emitter<SigninState> emit,
  ) {
    final email = Email.dirty(event.value);
    emit(
      state.copyWith(
        mEmail: email,
        mStatus: Formz.validate([email, state.mPassword]),
      ),
    );
  }

  void _onPasswordChnaged(
    SigninPasswordChanged event,
    Emitter<SigninState> emit,
  ) {
    final password = Password.dirty(event.value);
    emit(
      state.copyWith(
        mPassword: password,
        mStatus: Formz.validate([state.mEmail, password]),
      ),
    );
  }

  void _onSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    if (!state.mStatus.isValidated) return;

    emit(state.copyWith(mStatus: FormzStatus.submissionInProgress));

    try {
      await _authRepository.signInWithEmailAndPassword(
        email: state.mEmail.value,
        password: state.mPassword.value,
      );

      emit(state.copyWith(mStatus: FormzStatus.submissionSuccess));
    } on SignInWithEmailAndPasswordException catch (e) {
      emit(
        state.copyWith(
          mStatus: FormzStatus.submissionFailure,
          mError: e.message,
        ),
      );
    } on Exception catch (_) {
      emit(state.copyWith(mStatus: FormzStatus.submissionFailure));
    }
  }

  final AuthRepository _authRepository;
}
