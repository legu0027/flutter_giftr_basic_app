enum GiftrException {
  INVALID_TOKEN,
  INCORRECT_USERNAME_PASSWORD,
}

extension GiftrExceptionExtension on GiftrException {
  String get message {
    switch (this) {
      case GiftrException.INVALID_TOKEN:
        return 'Invalid Token, must sign in again';
      case GiftrException.INCORRECT_USERNAME_PASSWORD:
        return 'Incorrect username or password';
      default:
        return '';
    }
  }

  bool get shouldLogout {
    switch (this) {
      case GiftrException.INVALID_TOKEN:
        return true;
      default:
        return false;
    }
  }
}
