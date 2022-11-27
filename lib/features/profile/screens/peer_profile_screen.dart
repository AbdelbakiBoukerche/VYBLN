import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/repositories/user_repository.dart';
import '../../../common/services/user_cache.dart';
import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../blocs/peer_profile/peer_profile_bloc.dart';

class PeerProfileScreen extends StatelessWidget {
  static const String sPath = '/peer-profile-screen';
  const PeerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final peer = sl<UserCache>().user!;

    return BlocProvider(
      create: (context) => PeerProfileBloc(
        userRepository: sl<UserRepository>(),
        peer: peer,
      )..add(PeerProfileFetchStats()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          title: Text(peer.fullname!),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
              const SizedBox(height: 8.0),
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
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kScaffoldPaddingHoriz * 3,
                ),
                child: _FollowButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PeerProfileBloc>();

    return OutlinedButton(
      onPressed: () {
        if (bloc.state.isFollowed) {
          bloc.add(PeerProfileUnfollowRequested());
        } else {
          bloc.add(PeerProfileFollowRequested());
        }
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(36.0),
      ),
      child: BlocBuilder<PeerProfileBloc, PeerProfileState>(
        buildWhen: (previous, current) =>
            previous.isFollowed != current.isFollowed,
        builder: (context, state) {
          if (state.isFollowed) {
            return const Text('Unfollow');
          } else {
            return const Text('Follow');
          }
        },
      ),
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
        BlocBuilder<PeerProfileBloc, PeerProfileState>(
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
        BlocBuilder<PeerProfileBloc, PeerProfileState>(
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
        BlocBuilder<PeerProfileBloc, PeerProfileState>(
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
    final user = sl<UserCache>().user!;

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
    final user = sl<UserCache>().user!;

    return user.bio != null ? Text(user.bio!) : const SizedBox();
  }
}

class _Username extends StatelessWidget {
  const _Username({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = sl<UserCache>().user!;
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
    final user = sl<UserCache>().user!;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      user.fullname!,
      style: textTheme.bodyText1?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
