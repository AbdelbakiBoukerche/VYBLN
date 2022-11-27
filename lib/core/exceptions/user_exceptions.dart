class SaveUserToFirestoreException implements Exception {
  const SaveUserToFirestoreException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SaveUserToFirestoreException.fromCode(String code) {
    return SaveUserToFirestoreException(code);
  }

  final String message;
}

class GetUserFromFirestoreException implements Exception {
  const GetUserFromFirestoreException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory GetUserFromFirestoreException.fromCode(String code) {
    return GetUserFromFirestoreException(code);
  }

  final String message;
}

class UpdateUserInFirestoreException implements Exception {
  const UpdateUserInFirestoreException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory UpdateUserInFirestoreException.fromCode(String code) {
    return UpdateUserInFirestoreException(code);
  }

  final String message;
}

class UploadProfileImageException implements Exception {
  const UploadProfileImageException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory UploadProfileImageException.fromCode(String code) {
    return UploadProfileImageException(code);
  }

  final String message;
}

class FollowingPeerException implements Exception {
  const FollowingPeerException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FollowingPeerException.fromCode(String code) {
    return FollowingPeerException(code);
  }

  final String message;
}

class UnfollowingPeerException implements Exception {
  const UnfollowingPeerException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory UnfollowingPeerException.fromCode(String code) {
    return UnfollowingPeerException(code);
  }

  final String message;
}
