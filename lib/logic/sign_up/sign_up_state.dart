part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  final Email email;
  final Password password;
  final ConfirmPassword confirmedPassword;
  final FormzStatus status;

  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmPassword.pure(),
    this.status = FormzStatus.pure,
  });

  SignUpState copyWith({
    Email email,
    Password password,
    ConfirmPassword confirmedPassword,
    FormzStatus status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, confirmedPassword, status];
}
