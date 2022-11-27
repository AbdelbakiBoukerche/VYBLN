part of 'peer_profile_bloc.dart';

abstract class PeerProfileEvent extends Equatable {
  const PeerProfileEvent();

  @override
  List<Object> get props => [];
}

class PeerProfileFetchStats extends PeerProfileEvent {}

class PeerProfileFollowRequested extends PeerProfileEvent {}

class PeerProfileUnfollowRequested extends PeerProfileEvent {}
