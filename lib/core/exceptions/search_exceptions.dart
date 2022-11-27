class GetUsersFromFirestoreException implements Exception {
  const GetUsersFromFirestoreException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory GetUsersFromFirestoreException.fromCode(String code) {
    return GetUsersFromFirestoreException(code);
  }

  final String message;
}
