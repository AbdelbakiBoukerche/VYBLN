part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  final String value;

  const SignupEmailChanged(this.value);

  @override
  List<Object> get props => [value];
}

class SignupPasswordChanged extends SignupEvent {
  final String value;

  const SignupPasswordChanged(this.value);

  @override
  List<Object> get props => [value];
}

class SignupUsernameChanged extends SignupEvent {
  final String value;

  const SignupUsernameChanged(this.value);

  @override
  List<Object> get props => [value];
}

class SignupFullnameChanged extends SignupEvent {
  final String value;

  const SignupFullnameChanged(this.value);

  @override
  List<Object> get props => [value];
}

class SignupSubmitted extends SignupEvent {}
