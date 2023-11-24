// storage_service.dart

// ignore_for_file: non_constant_identifier_names
//Logan S
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

  Future<String?> GETSESSMTPUSERNAME() async {
    return await _storage.read(key: 'Username');
  }

  Future<void> SETSESSMTPUSERNAME(String Username) async {
    await _storage.write(key: 'Username', value: Username);
  }

Future<String?> GETSESSMTPPASSWORD() async {
    return await _storage.read(key: 'password');
  }

  Future<void> SETSESSMTPPASSWORD(String Password) async {
    await _storage.write(key: 'Password', value: Password);
  }


  // Add more methods as needed...
}
