import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:pointycastle/pointycastle.dart';

import '../../../../common/models/email.dart';
import '../../../../common/models/full_name.dart';
import '../../../../common/models/password.dart';
import '../../../../common/models/username.dart';
import '../../../../common/services/rsa_service.dart';
import '../../../../core/exceptions/auth_exceptions.dart';
import '../../../../core/injection_container.dart';
import '../../../../utils/crypto_utils.dart';
import '../../repositories/auth_repository.dart';
import '../auth/auth_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthRepository authRepository,
    required RSAService rsaService,
  })  : _authRepository = authRepository,
        _rsaService = rsaService,
        super(const SignupState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupUsernameChanged>(_onUsernameChanged);
    on<SignupFullnameChanged>(_onFullnameChanged);
    on<SignupSubmitted>(_onSubmitted);

    _subscription = sl<AuthBloc>().stream.listen((event) async {
      if (event is AuthUserAuthenticated) {
        await sl<FlutterSecureStorage>().write(
          key: '${event.mUser.uid}-PEM',
          value: CryptoUtils.encodeRSAPrivateKeyToPem(_keyPair!.privateKey),
        );
      }
    });
  }

  late final StreamSubscription<void> _subscription;
  late final AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>? _keyPair;

  void _onEmailChanged(
    SignupEmailChanged event,
    Emitter<SignupState> emit,
  ) {
    final email = Email.dirty(event.value);
    emit(
      state.copyWith(
        mEmail: email,
        mStatus: Formz.validate([
          email,
          state.mPassword,
          state.mUsername,
          state.mFullname,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = Password.dirty(event.value);
    emit(
      state.copyWith(
        mPassword: password,
        mStatus: Formz.validate([
          state.mEmail,
          password,
          state.mUsername,
          state.mFullname,
        ]),
      ),
    );
  }

  void _onUsernameChanged(
    SignupUsernameChanged event,
    Emitter<SignupState> emit,
  ) {
    final username = Username.dirty(event.value);
    emit(
      state.copyWith(
        mUsername: username,
        mStatus: Formz.validate([
          state.mEmail,
          state.mPassword,
          username,
          state.mFullname,
        ]),
      ),
    );
  }

  void _onFullnameChanged(
    SignupFullnameChanged event,
    Emitter<SignupState> emit,
  ) {
    final fullname = Fullname.dirty(event.value);
    emit(
      state.copyWith(
        mFullname: fullname,
        mStatus: Formz.validate([
          state.mEmail,
          state.mPassword,
          state.mUsername,
          fullname,
        ]),
      ),
    );
  }

  void _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.mStatus.isValidated) return;

    emit(state.copyWith(mStatus: FormzStatus.submissionInProgress));

    try {
      _keyPair = await _rsaService.generateRSAKeyPair();

      final publicPEM = CryptoUtils.encodeRSAPublicKeyToPem(
        _keyPair!.publicKey,
      );

      await _authRepository.signupWithEmailAndPassword(
        email: state.mEmail.value,
        password: state.mPassword.value,
        data: {
          'email': state.mEmail.value,
          'username': state.mUsername.value,
          'fullname': state.mFullname.value,
          'publicPEM': publicPEM,
        },
      );

      emit(state.copyWith(mStatus: FormzStatus.submissionSuccess));
    } on SignUpWithEmailAndPasswordException catch (e) {
      emit(
        state.copyWith(
          mStatus: FormzStatus.submissionFailure,
          mError: e.message,
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(mStatus: FormzStatus.submissionFailure));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();

    return super.close();
  }

  final AuthRepository _authRepository;
  final RSAService _rsaService;
}
