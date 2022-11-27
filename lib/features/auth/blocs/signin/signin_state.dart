part of 'signin_bloc.dart';

class SigninState extends Equatable {
  const SigninState({
    this.mEmail = const Email.pure(),
    this.mPassword = const Password.pure(),
    this.mStatus = FormzStatus.pure,
    this.mError,
  });

  SigninState copyWith({
    Email? mEmail,
    Password? mPassword,
    FormzStatus? mStatus,
    String? mError,
  }) {
    return SigninState(
      mEmail: mEmail ?? this.mEmail,
      mPassword: mPassword ?? this.mPassword,
      mStatus: mStatus ?? this.mStatus,
      mError: mError ?? this.mError,
    );
  }

  @override
  List<Object?> get props => [mEmail, mPassword, mStatus, mError];

  final Email mEmail;
  final Password mPassword;
  final FormzStatus mStatus;
  final String? mError;
}
