import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/models/user.dart';
import '../models/chat.dart';

class ChatRepository {
  final _usersRef = FirebaseFirestore.instance.collection('users');
  final _chatsRef = FirebaseFirestore.instance.collection('chats');

  Future<List<Chat>> getChats(User user) async {
    final chats = <Chat>[];
    // Get current user DocumentReference
    final userDocRef = _usersRef.doc(user.uid);

    // Get chats for current user
    final result =
        await _chatsRef.where('users', arrayContainsAny: [userDocRef]).get();

    for (var doc in result.docs) {
      // Cast List<dynamic> to List<DocumentReference>
      final usersDocRef = (doc.data()['users'] as List)
          .map((e) => e as DocumentReference)
          .toList();

      // Filter out the current user uid
      final peerDocRef =
          usersDocRef.where((element) => element.id != user.uid).first;

      final docSnap = await peerDocRef.get();

      final peer = User.fromMap(docSnap.data() as Map<String, dynamic>);
      final chat = Chat(peer: peer, lastMessage: '');
      chats.add(chat);
    }
    return chats;
  }

  // String _getChatID(String userID, String peerID) {
  //   return userID.hashCode >= peerID.hashCode
  //       ? '${userID}_$peerID'
  //       : '${peerID}_$userID';
  // }
}
