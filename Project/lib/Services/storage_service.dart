// storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = FlutterSecureStorage();

  Future<String?> getStoredToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> setStoredToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getStoredUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> setStoredUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  // Add more methods as needed...
}
