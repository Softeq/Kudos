class AuthError extends Error {
  final String message;
  final Error internalError;

  AuthError(this.message, this.internalError);

  @override
  String toString() {
    return 'AuthException: $message, internal: $internalError';
  }
}
