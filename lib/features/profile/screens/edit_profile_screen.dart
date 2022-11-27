import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../common/extensions/fullname_ext.dart';
import '../../../common/extensions/username_ext.dart';
import '../../../common/repositories/user_repository.dart';
import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../../auth/blocs/auth/auth_bloc.dart';
import '../blocs/edit_profile/edit_profile_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  static const String sPath = '/edit-profile';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;

    return BlocProvider(
      create: (context) => EditProfileBloc(userRepository: sl<UserRepository>())
        ..add(EditProfileFullnameChanged(user.fullname ?? ''))
        ..add(EditProfileUsernameChanged(user.username ?? ''))
        ..add(EditProfileBioChanged(user.bio ?? '')),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message ?? "Couldn't update profile"),
                ),
              );
          }
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message ?? "Profile Updated!"),
                ),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            automaticallyImplyLeading: false,
            title: const Text('Edit Profile'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: const Icon(Icons.close_rounded),
            ),
            actions: const [
              _SubmitButton(),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const _ProgressIndicator(),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(kScaffoldPaddingHoriz),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      _ProfilePhoto(),
                      _ChangePhotoButton(),
                      SizedBox(height: 24.0),
                      _FullnameInput(),
                      SizedBox(height: 16.0),
                      _UsernameInput(),
                      SizedBox(height: 16.0),
                      _BioInput(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return const LinearProgressIndicator();
        }
        return const SizedBox();
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();

    return IconButton(
      onPressed: () {
        bloc.add(EditProfileSubmitted());
      },
      icon: const Icon(Icons.check_rounded),
    );
  }
}

class _BioInput extends HookWidget {
  const _BioInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
    final controller = useTextEditingController(text: user.bio);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bio'),
        BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            return TextField(
              controller: controller,
              onChanged: (value) {
                bloc.add(EditProfileBioChanged(value));
              },
              maxLines: 3,
              maxLength: 127,
              decoration: const InputDecoration(isDense: true),
            );
          },
        ),
      ],
    );
  }
}

class _UsernameInput extends HookWidget {
  const _UsernameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
    final controller = useTextEditingController(text: user.username);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username'),
        BlocBuilder<EditProfileBloc, EditProfileState>(
          buildWhen: (previous, current) =>
              previous.username != current.username,
          builder: (context, state) {
            return TextField(
              controller: controller,
              onChanged: (value) {
                bloc.add(EditProfileUsernameChanged(value));
              },
              decoration: InputDecoration(
                isDense: true,
                errorText: state.username.invalid
                    ? state.username.error?.text()
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FullnameInput extends HookWidget {
  const _FullnameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
    final controller = useTextEditingController(text: user.fullname);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fullname'),
        BlocBuilder<EditProfileBloc, EditProfileState>(
          buildWhen: (previous, current) =>
              previous.fullname != current.fullname,
          builder: (context, state) {
            return TextField(
              controller: controller,
              onChanged: (value) {
                bloc.add(EditProfileFullnameChanged(value));
              },
              decoration: InputDecoration(
                isDense: true,
                errorText: state.fullname.invalid
                    ? state.fullname.error?.text()
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ChangePhotoButton extends StatelessWidget {
  const _ChangePhotoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();

    return TextButton(
      onPressed: () {
        bloc.add(EditProfilePhotoChanged());
      },
      child: const Text('Change Profile Photo'),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    Key? key,
  }) : super(key: key);

  ImageProvider _getImage(String? photoURL, EditProfileState state) {
    if (state.image != null) {
      return FileImage(state.image!);
    }
    if (photoURL != null) {
      return CachedNetworkImageProvider(photoURL);
    }
    return const AssetImage('assets/images/blank-profile-picture.png');
  }

  @override
  Widget build(BuildContext context) {
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;

    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<EditProfileBloc, EditProfileState>(
          buildWhen: (previous, current) => previous.image != current.image,
          builder: (context, state) {
            return CircleAvatar(
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              radius: constraints.maxWidth * 0.1,
              backgroundImage: _getImage(user.photoURL, state),
            );
          },
        );
      },
    );
  }
}
