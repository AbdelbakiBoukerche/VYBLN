import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/models/user.dart';
import '../../../core/exceptions/search_exceptions.dart';

class SearchRepository {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<List<User>> getUsersByUsername(String username) async {
    try {
      final result = await _usersRef
          .where('username', isGreaterThanOrEqualTo: username)
          .get();

      return result.docs.map((e) => User.fromMap(e.data())).toList();
    } on FirebaseException catch (e) {
      throw GetUsersFromFirestoreException(e.code);
    } on Exception catch (_) {
      throw const GetUsersFromFirestoreException();
    }
  }
}
