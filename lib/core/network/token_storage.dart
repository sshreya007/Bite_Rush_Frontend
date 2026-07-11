import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';

/// Thin wrapper around flutter_secure_storage for the auth token.
/// Every feature that needs "is the user logged in" reads through
/// this, so there's one place that knows the storage key name.
class TokenStorage {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;

  const TokenStorage(this._storage);

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw const CacheException('Failed to save auth token');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      throw const CacheException('Failed to read auth token');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      throw const CacheException('Failed to delete auth token');
    }
  }
}
