// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'messaging_bloc.dart';

class MessagingState extends Equatable {
  const MessagingState({
    required this.user,
    required this.peer,
  });

  final User user;
  final User peer;

  MessagingState copyWith({
    User? user,
    User? peer,
  }) {
    return MessagingState(
      user: user ?? this.user,
      peer: peer ?? this.peer,
    );
  }

  @override
  List<Object> get props => [user, peer];
}
