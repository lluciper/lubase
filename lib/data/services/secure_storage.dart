import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'local_storage_key.dart';

/// LocalAuthStorage centralizes all auth-related token persistence.
class SecureStorage {
  SecureStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  final _tokensCleared = ValueNotifier<int>(0);

  /// Notifies after [clearTokens] (logout, expired session). The router
  /// listens to it to leave screens that need login.
  Listenable get tokensCleared => _tokensCleared;

  /// Grows on every [clearTokens]: a refresh started before a logout compares
  /// it so it does not save tokens afterwards.
  int get clearedCount => _tokensCleared.value;

  Future<String?> getString(String key) => _secureStorage.read(key: key);

  Future<bool> setString(String key, String value) => _secureStorage
      .write(key: key, value: value)
      .then((_) => true, onError: (Object _) => false);

  String? _accessToken;
  bool _accessTokenLoaded = false;

  /// Cached after the first read: the interceptor and the login guard ask for
  /// it on every request and navigation, and a Keychain/Keystore read is slow.
  Future<String?> getAccessToken() async {
    if (!_accessTokenLoaded) {
      _accessToken = await getString(LocalStorageKey.accessToken);
      _accessTokenLoaded = true;
    }
    return _accessToken;
  }

  Future<bool> saveAccessToken(String token) async {
    final saved = await setString(LocalStorageKey.accessToken, token);
    if (saved) {
      _accessToken = token;
      _accessTokenLoaded = true;
    }
    return saved;
  }

  Future<bool> saveRefreshToken(String token) =>
      setString(LocalStorageKey.refreshToken, token);

  Future<String?> getRefreshToken() => getString(LocalStorageKey.refreshToken);

  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: LocalStorageKey.accessToken),
      _secureStorage.delete(key: LocalStorageKey.refreshToken),
    ]);
    _accessToken = null;
    _accessTokenLoaded = true;
    _tokensCleared.value++;
  }
}
