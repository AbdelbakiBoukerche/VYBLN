import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../../../core/routing/app_router.dart';
import '../../auth/blocs/auth/auth_bloc.dart';
import '../blocs/profile/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 2.0,
          title: const Text('My Profile'),
          centerTitle: true,
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: kScaffoldPaddingHoriz,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const _ProfilePhoto(),
              const SizedBox(height: 8.0),
              const _Fullname(),
              const _Username(),
              const SizedBox(height: 12.0),
              const _Bio(),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kScaffoldPaddingHoriz * 3,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _PostsCount(),
                      VerticalDivider(
                        indent: 4.0,
                        endIndent: 4.0,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                      const _FollowersCount(),
                      VerticalDivider(
                        indent: 4.0,
                        endIndent: 4.0,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                      const _FollowingCount(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kScaffoldPaddingHoriz * 3,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 4,
                      child: OutlinedButton(
                        onPressed: () {
                          GoRouter.of(context).push(
                            AppRouter.sEditProfilePath,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(36.0),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthSignOutRequested());
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(36.0),
                        ),
                        child: const Icon(Icons.logout_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FollowingCount extends StatelessWidget {
  const _FollowingCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.followingCount != current.followingCount,
          builder: (context, state) {
            return Text(
              state.followingCount.toString(),
              style: textTheme.bodyText1?.copyWith(
                fontSize: 16.0,
              ),
            );
          },
        ),
        Text('Following', style: textTheme.caption),
      ],
    );
  }
}

class _FollowersCount extends StatelessWidget {
  const _FollowersCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.followersCount != current.followersCount,
          builder: (context, state) {
            return Text(
              state.followersCount.toString(),
              style: textTheme.bodyText1?.copyWith(
                fontSize: 16.0,
              ),
            );
          },
        ),
        Text('Followers', style: textTheme.caption),
      ],
    );
  }
}

class _PostsCount extends StatelessWidget {
  const _PostsCount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.postsCount != current.postsCount,
          builder: (context, state) {
            return Text(
              state.postsCount.toString(),
              style: textTheme.bodyText1?.copyWith(
                fontSize: 16.0,
              ),
            );
          },
        ),
        Text('Posts', style: textTheme.caption),
      ],
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    Key? key,
  }) : super(key: key);

  ImageProvider _getImage(String? photoURL) {
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
        return CircleAvatar(
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          radius: constraints.maxWidth * 0.1,
          backgroundImage: _getImage(user.photoURL),
        );
      },
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;

    return user.bio != null ? Text(user.bio!) : const SizedBox();
  }
}

class _Username extends StatelessWidget {
  const _Username({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      '@${user.username!}',
      style: textTheme.caption,
    );
  }
}

class _Fullname extends StatelessWidget {
  const _Fullname({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      user.fullname!,
      style: textTheme.bodyText1?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
