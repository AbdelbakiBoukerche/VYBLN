part of 'chats_bloc.dart';

class ChatsState extends Equatable {
  const ChatsState({
    this.chats = const [],
  });

  final List<Chat> chats;

  ChatsState copyWith({
    List<Chat>? chats,
  }) {
    return ChatsState(
      chats: chats ?? this.chats.map((e) => e.copyWith()).toList(),
    );
  }

  @override
  List<Object> get props => [chats];
}
