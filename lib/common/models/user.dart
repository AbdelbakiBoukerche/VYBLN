import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/pointycastle.dart';

import '../../core/injection_container.dart';
import '../../utils/crypto_utils.dart';

class User extends Equatable {
  const User({
    required this.uid,
    this.email,
    this.username,
    this.fullname,
    this.bio,
    this.photoURL,
    this.publicPEM,
  });

  static const sEmpty = User(uid: '');

  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? fullname,
    String? bio,
    String? photoURL,
    String? publicPEM,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      bio: bio ?? this.bio,
      photoURL: photoURL ?? this.photoURL,
      publicPEM: publicPEM ?? this.publicPEM,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      publicPEM: map['publicPEM'] != null ? map['publicPEM'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'fullname': fullname,
      'bio': bio,
      'photoURL': photoURL,
      'publicPEM': publicPEM,
    };
  }

  bool get isEmpty => this == User.sEmpty;
  bool get isNotEmpty => this != User.sEmpty;

  Future<RSAPrivateKey?> getPrivateKey() async {
    final pem = await sl<FlutterSecureStorage>().read(key: '$uid-PEM');
    if (pem != null) {
      return CryptoUtils.rsaPrivateKeyFromPem(pem);
    }
    return null;
  }

  Future<RSAPublicKey?> getPublicKey() async {
    if (publicPEM != null) {
      return CryptoUtils.rsaPublicKeyFromPem(publicPEM!);
    }
    return null;
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        username,
        fullname,
        bio,
        photoURL,
        publicPEM,
      ];

  final String uid;
  final String? email;
  final String? username;
  final String? fullname;
  final String? bio;
  final String? photoURL;
  final String? publicPEM;
}
