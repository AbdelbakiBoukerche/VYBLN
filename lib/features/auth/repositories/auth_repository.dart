import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../common/models/user.dart';
import '../../../common/repositories/user_repository.dart';
import '../../../core/exceptions/auth_exceptions.dart';
import '../../../core/exceptions/user_exceptions.dart';

class AuthRepository {
  const AuthRepository({
    required auth.FirebaseAuth firebaseAuth,
    required UserRepository userRepository,
  })  : _firebaseAuth = firebaseAuth,
        _userRepository = userRepository;

  final auth.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  Stream<User> get user => _firebaseAuth.authStateChanges().asyncMap(
        (event) async {
          if (event == null) {
            return User.sEmpty;
          } else {
            return await _userRepository.getUserFromFirestore(event.uid) ??
                User.sEmpty;
          }
        },
      );

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordException.fromCode(e.code);
    } on Exception catch (_) {
      throw const SignInWithEmailAndPasswordException();
    }
  }

  Future<void> signupWithEmailAndPassword({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_firebaseAuth.currentUser != null) {
        data['uid'] = _firebaseAuth.currentUser!.uid;
        await _userRepository.saveUserToFirestore(User.fromMap(data));
      }
    } on auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordException.fromCode(e.code);
    } on SaveUserToFirestoreException catch (_) {
      rethrow;
    } on Exception catch (_) {
      throw const SignUpWithEmailAndPasswordException();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception catch (_) {
      throw SignOutException();
    }
  }
}
