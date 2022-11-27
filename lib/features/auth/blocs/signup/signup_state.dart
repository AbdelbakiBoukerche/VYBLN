part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    this.mEmail = const Email.pure(),
    this.mPassword = const Password.pure(),
    this.mUsername = const Username.pure(),
    this.mFullname = const Fullname.pure(),
    this.mStatus = FormzStatus.pure,
    this.mError,
  });

  SignupState copyWith({
    Email? mEmail,
    Password? mPassword,
    Username? mUsername,
    Fullname? mFullname,
    FormzStatus? mStatus,
    String? mError,
  }) {
    return SignupState(
      mEmail: mEmail ?? this.mEmail,
      mPassword: mPassword ?? this.mPassword,
      mUsername: mUsername ?? this.mUsername,
      mFullname: mFullname ?? this.mFullname,
      mStatus: mStatus ?? this.mStatus,
      mError: mError ?? this.mError,
    );
  }

  @override
  List<Object?> get props => [
        mEmail,
        mPassword,
        mUsername,
        mFullname,
        mStatus,
        mError,
      ];

  final Email mEmail;
  final Password mPassword;
  final Username mUsername;
  final Fullname mFullname;
  final FormzStatus mStatus;
  final String? mError;
}
