part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfilePhotoChanged extends EditProfileEvent {}

class EditProfileFullnameChanged extends EditProfileEvent {
  const EditProfileFullnameChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class EditProfileUsernameChanged extends EditProfileEvent {
  const EditProfileUsernameChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class EditProfileBioChanged extends EditProfileEvent {
  const EditProfileBioChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class EditProfileSubmitted extends EditProfileEvent {}
