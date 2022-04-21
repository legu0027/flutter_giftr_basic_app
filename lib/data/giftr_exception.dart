enum GiftrException {
  INVALID_TOKEN,
}

extension GiftrExceptionExtension on GiftrException {
  String get message {
    switch (this) {
      case GiftrException.INVALID_TOKEN:
        return 'Invalid Token, must sign in again';
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
