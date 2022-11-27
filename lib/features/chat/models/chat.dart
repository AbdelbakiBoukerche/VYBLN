import 'package:equatable/equatable.dart';

import '../../../common/models/user.dart';

class Chat extends Equatable {
  const Chat({
    required this.peer,
    required this.lastMessage,
  });

  Chat copyWith({
    User? peer,
    String? lastMessage,
  }) {
    return Chat(
      peer: peer ?? this.peer,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  final User peer;
  final String lastMessage;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'peer': peer.toMap(),
      'lastMessage': lastMessage,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      peer: User.fromMap(map['peer'] as Map<String, dynamic>),
      lastMessage: map['lastMessage'] as String,
    );
  }

  @override
  List<Object?> get props => [peer, lastMessage];
}
