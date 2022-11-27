part of 'peer_profile_bloc.dart';

class PeerProfileState extends Equatable {
  const PeerProfileState({
    required this.peer,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isFollowed = false,
  });

  final User peer;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowed;

  PeerProfileState copyWith({
    User? peer,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isFollowed,
  }) {
    return PeerProfileState(
      peer: peer ?? this.peer,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }

  @override
  List<Object> get props => [
        peer,
        followersCount,
        followingCount,
        postsCount,
        isFollowed,
      ];
}
