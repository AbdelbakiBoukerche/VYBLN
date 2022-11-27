import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../core/exceptions/user_exceptions.dart';
import '../models/user.dart';

class UserRepository {
  final _usersRef = FirebaseFirestore.instance.collection('users');
  final _chatsRef = FirebaseFirestore.instance.collection('chats');

  Future<void> saveUserToFirestore(User user) async {
    try {
      await _usersRef.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      throw SaveUserToFirestoreException.fromCode(e.code);
    } on Exception catch (_) {
      throw const SaveUserToFirestoreException();
    }
  }

  Future<User?> getUserFromFirestore(String uid) async {
    try {
      final doc = await _usersRef.doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return User.fromMap(doc.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      throw GetUserFromFirestoreException.fromCode(e.code);
    } on Exception catch (_) {
      throw const GetUserFromFirestoreException();
    }
  }

  Future<void> updateUserInFirestore({required User user}) async {
    try {
      await _usersRef.doc(user.uid).update(user.toMap());
    } on FirebaseException catch (e) {
      throw UpdateUserInFirestoreException.fromCode(e.code);
    } on Exception catch (_) {
      throw const UpdateUserInFirestoreException();
    }
  }

  Future<String> uploadProfileImage({
    required File file,
    required User user,
  }) async {
    try {
      final ext = file.path.split('.').last;

      final uuid = const Uuid().v4();

      final uploadTask = FirebaseStorage.instance
          .ref('uploads/${user.uid}/$uuid.$ext')
          .putFile(file);

      return await (await uploadTask).ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw UploadProfileImageException(e.code);
    } on Exception catch (_) {
      throw const UploadProfileImageException();
    }
  }

  Future<int> getFollowersCount({required String userID}) async {
    final result =
        await _usersRef.doc(userID).collection('followers').count().get();
    return result.count;
  }

  Future<int> getFollowingCount({required String userID}) async {
    final result =
        await _usersRef.doc(userID).collection('following').count().get();
    return result.count;
  }

  Future<int> getPostsCount({required String userID}) async {
    return 0;
  }

  Future<bool> isPeerFollowed({
    required String userID,
    required String peerID,
  }) async {
    final result =
        await _usersRef.doc(userID).collection('following').doc(peerID).get();

    if (result.exists) {
      return true;
    }
    return false;
  }

  Future<void> followUser({
    required User user,
    required User peer,
  }) async {
    try {
      final peerRef = _usersRef.doc(peer.uid);
      // 1) Add peer to current user followings
      await _usersRef
          .doc(user.uid)
          .collection('following')
          .doc(peer.uid)
          .set({'user': peerRef});

      // 2) Add user to peer followers
      final userRef = _usersRef.doc(user.uid);
      await _usersRef
          .doc(peer.uid)
          .collection('followers')
          .doc(user.uid)
          .set({'user': userRef});

      // 3) Create a chat collection if one doesn't exists
      final chatID = _getChatID(user.uid, peer.uid);
      await _chatsRef.doc(chatID).set({
        'users': [userRef, peerRef],
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Create First message
      await _chatsRef.doc(chatID).collection('messages').doc().set({
        'sentAt': FieldValue.serverTimestamp(),
        'type': 'system',
        'content': 'This is the start of your conversation'
      });
    } on FirebaseException catch (e) {
      throw FollowingPeerException.fromCode(e.code);
    } on Exception catch (_) {
      throw const FollowingPeerException();
    }
  }

  Future<void> unfollowUser({
    required User user,
    required User peer,
  }) async {
    try {
      // 1) Remove peer from current user followings
      await _usersRef
          .doc(user.uid)
          .collection('following')
          .doc(peer.uid)
          .delete();

      // 2) Remove user from peer followers
      await _usersRef
          .doc(peer.uid)
          .collection('followers')
          .doc(user.uid)
          .delete();
    } on FirebaseException catch (e) {
      throw UnfollowingPeerException.fromCode(e.code);
    } on Exception catch (_) {
      throw const UnfollowingPeerException();
    }
  }

  String _getChatID(String userID, String peerID) {
    return userID.hashCode >= peerID.hashCode
        ? '${userID}_$peerID'
        : '${peerID}_$userID';
  }
}
