part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.image,
    this.fullname = const Fullname.pure(),
    this.username = const Username.pure(),
    this.status = FormzStatus.pure,
    this.bio,
    this.message,
  });
  EditProfileState copyWith({
    File? image,
    Fullname? fullname,
    Username? username,
    String? bio,
    FormzStatus? status,
    String? message,
  }) {
    return EditProfileState(
      image: image ?? this.image,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  final File? image;
  final Fullname fullname;
  final Username username;
  final String? bio;
  final FormzStatus status;
  final String? message;

  @override
  List<Object?> get props => [image, fullname, username, bio, status, message];
}
