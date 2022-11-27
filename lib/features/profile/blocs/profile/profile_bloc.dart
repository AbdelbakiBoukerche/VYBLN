import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/user.dart';
import '../../../../common/repositories/user_repository.dart';
import '../../../../core/injection_container.dart';
import '../../../auth/blocs/auth/auth_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ProfileState()) {
    on<ProfileFetchStats>(_onFetchStats);
  }

  final UserRepository _userRepository;

  final User _user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;

  void _onFetchStats(
    ProfileFetchStats event,
    Emitter<ProfileState> emit,
  ) async {
    final postsCount = await _userRepository.getPostsCount(userID: _user.uid);
    final followersCount =
        await _userRepository.getFollowersCount(userID: _user.uid);
    final followingCount =
        await _userRepository.getFollowingCount(userID: _user.uid);

    emit(
      state.copyWith(
        postsCount: postsCount,
        followersCount: followersCount,
        followingCount: followingCount,
      ),
    );
  }
}
