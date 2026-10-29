class LocalStorageKey {
  LocalStorageKey._();

  // Auth key

  static const String _prefixAuth = 'auth';
  static const String refreshToken = '${_prefixAuth}_refresh_token';
  static const String accessToken = '${_prefixAuth}_access_token';

  // App
  static const String installed = 'app_installed';
}
