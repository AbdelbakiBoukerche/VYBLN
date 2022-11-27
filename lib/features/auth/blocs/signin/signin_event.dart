part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SigninEmailChanged extends SigninEvent {
  final String value;

  const SigninEmailChanged(this.value);

  @override
  List<Object> get props => [value];
}

class SigninPasswordChanged extends SigninEvent {
  final String value;

  const SigninPasswordChanged(this.value);

  @override
  List<Object> get props => [value];
}

class SigninSubmitted extends SigninEvent {}
