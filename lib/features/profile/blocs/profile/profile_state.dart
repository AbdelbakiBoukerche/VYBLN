part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
  });

  final int followersCount;
  final int followingCount;
  final int postsCount;

  ProfileState copyWith({
    User? user,
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) {
    return ProfileState(
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
    );
  }

  @override
  List<Object> get props => [
        followersCount,
        followingCount,
        postsCount,
      ];
}
