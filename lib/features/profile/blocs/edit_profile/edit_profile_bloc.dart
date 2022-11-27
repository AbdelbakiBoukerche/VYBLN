import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vybln/common/repositories/user_repository.dart';
import 'package:vybln/core/exceptions/user_exceptions.dart';
import 'package:vybln/features/auth/blocs/auth/auth_bloc.dart';

import '../../../../common/models/full_name.dart';
import '../../../../common/models/username.dart';
import '../../../../core/injection_container.dart';
import '../../../../utils/v_image_cropper.dart';
import '../../../../utils/v_image_picker.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const EditProfileState()) {
    on<EditProfilePhotoChanged>(_onPhotoChanged);
    on<EditProfileFullnameChanged>(_onFullnameChanged);
    on<EditProfileUsernameChanged>(_onUsernameChanged);
    on<EditProfileBioChanged>(_onBioChanged);
    on<EditProfileSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onPhotoChanged(
    EditProfilePhotoChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    var image = await sl<VImagePicker>().pickImage();

    if (image == null) {
      state.copyWith(image: image);
    }

    image = await sl<VImageCropper>().cropImage(
      image!.path,
      aspectRatio: VAspectRatio.oneToOne(),
    );
    emit(state.copyWith(image: image));
  }

  void _onFullnameChanged(
    EditProfileFullnameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    final fullname = Fullname.dirty(event.value);

    emit(
      state.copyWith(
        fullname: fullname,
        status: Formz.validate([fullname, state.username]),
      ),
    );
  }

  void _onUsernameChanged(
    EditProfileUsernameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    final username = Username.dirty(event.value);

    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([state.fullname, username]),
      ),
    );
  }

  void _onBioChanged(
    EditProfileBioChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        bio: event.value,
      ),
    );
  }

  void _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.status.isInvalid) {
      return emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: 'Make sure Fullname and Username are correct',
        ),
      );
    }
    // TODO: Update only the changed data

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      var user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
      if (state.image != null) {
        final photoURL = await _userRepository.uploadProfileImage(
          file: state.image!,
          user: user,
        );
        user = user.copyWith(
          photoURL: photoURL,
          bio: state.bio,
          fullname: state.fullname.value,
          username: state.username.value,
        );
      }

      await _userRepository.updateUserInFirestore(user: user);
    } on UploadProfileImageException catch (e) {
      return emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    } on UpdateUserInFirestoreException catch (e) {
      return emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          message: e.message,
        ),
      );
    } on Exception catch (_) {
      return emit(
        state.copyWith(status: FormzStatus.submissionFailure),
      );
    }

    return emit(state.copyWith(status: FormzStatus.submissionSuccess));
  }
}
