import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/user.dart';
import '../../../../common/repositories/user_repository.dart';
import '../../../../core/injection_container.dart';
import '../../../auth/blocs/auth/auth_bloc.dart';

part 'peer_profile_event.dart';
part 'peer_profile_state.dart';

class PeerProfileBloc extends Bloc<PeerProfileEvent, PeerProfileState> {
  PeerProfileBloc({
    required UserRepository userRepository,
    required User peer,
  })  : _userRepository = userRepository,
        super(PeerProfileState(peer: peer)) {
    on<PeerProfileFetchStats>(_onFetchStates);
    on<PeerProfileFollowRequested>(_onFollowRequested);
    on<PeerProfileUnfollowRequested>(_onUnfollowRequested);
  }

  final UserRepository _userRepository;
  final User _user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;

  void _onFetchStates(
    PeerProfileFetchStats event,
    Emitter<PeerProfileState> emit,
  ) async {
    final postsCount = await _getPostsCount(state.peer.uid);
    final followersCount = await _getFollowersCount(state.peer.uid);
    final followingCount = await _getFollowingCount(state.peer.uid);

    final isFollowed = await _userRepository.isPeerFollowed(
      userID: _user.uid,
      peerID: state.peer.uid,
    );

    emit(
      state.copyWith(
        postsCount: postsCount,
        followersCount: followersCount,
        followingCount: followingCount,
        isFollowed: isFollowed,
      ),
    );
  }

  void _onFollowRequested(
    PeerProfileFollowRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    await _userRepository.followUser(
      user: _user,
      peer: state.peer,
    );
    final followersCount = await _getFollowersCount(state.peer.uid);
    emit(state.copyWith(isFollowed: true, followersCount: followersCount));
  }

  void _onUnfollowRequested(
    PeerProfileUnfollowRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    await _userRepository.unfollowUser(
      user: _user,
      peer: state.peer,
    );

    final followersCount = await _getFollowersCount(state.peer.uid);
    emit(state.copyWith(isFollowed: false, followersCount: followersCount));
  }

  Future<int> _getFollowersCount(String id) async {
    return await _userRepository.getFollowersCount(userID: id);
  }

  Future<int> _getFollowingCount(String id) async {
    return await _userRepository.getFollowingCount(userID: id);
  }

  Future<int> _getPostsCount(String id) async {
    return await _userRepository.getPostsCount(userID: id);
  }
}
