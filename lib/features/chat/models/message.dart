import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.peerID,
    required this.userID,
    this.senderID,
    required this.content,
    required this.contentPeer,
    required this.contentUser,
    required this.sentAt,
    this.type = 'text',
  });
  final String peerID;
  final String userID;
  final String content;
  final String contentPeer;
  final String contentUser;
  final String type;
  final DateTime sentAt;
  final String? senderID;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'type': type,
      'sentAt': sentAt.millisecondsSinceEpoch,
      'senderID': senderID,
    };
  }

  factory Message.fromMap(
    Map<String, dynamic> map, {
    required String userID,
    required String peerID,
  }) {
    return Message(
      userID: userID,
      peerID: peerID,
      contentPeer: map['content-$peerID'] != null
          ? map['content-$peerID'] as String
          : '',
      contentUser: map['content-$userID'] != null
          ? map['content-$userID'] as String
          : '',
      content: map['content'] != null ? map['content'] as String : 'N/A',
      type: map['type'] as String,
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      senderID: map['senderID'] as String?,
    );
  }
  @override
  List<Object?> get props => [senderID, content, sentAt, type];
}
