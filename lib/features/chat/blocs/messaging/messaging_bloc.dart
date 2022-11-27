import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/models/user.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc({
    required User user,
    required User peer,
  }) : super(MessagingState(user: user, peer: peer)) {
    on<MessagingSendMessage>(_onMessageSent);
  }

  String chatID() {
    return state.user.uid.hashCode >= state.peer.uid.hashCode
        ? '${state.user.uid}_${state.peer.uid}'
        : '${state.peer.uid}_${state.user.uid}';
  }

  void _onMessageSent(
    MessagingSendMessage event,
    Emitter<MessagingState> emit,
  ) async {
    if (event.value.trim().isEmpty) return;

    // Get users RSA Public Keys
    final userPub = await state.user.getPublicKey();
    final peerPub = await state.peer.getPublicKey();

    // Create Encrypters for both users
    final userEncrypter = Encrypter(RSA(publicKey: userPub));
    final peerEncrypter = Encrypter(RSA(publicKey: peerPub));

    // Encrypt the plain text
    final userCipher = userEncrypter.encrypt(event.value);
    final peerCipher = peerEncrypter.encrypt(event.value);

    // Save the message to Firestore
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID())
        .collection('messages')
        .doc()
        .set({
      'senderID': state.user.uid,
      'type': 'text',
      'sentAt': FieldValue.serverTimestamp(),
      'content-${state.peer.uid}': peerCipher.base64,
      'content-${state.user.uid}': userCipher.base64,
      'content': null,
    });

    emit(state.copyWith());
  }
}
