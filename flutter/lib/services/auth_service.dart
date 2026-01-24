import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/auth_api.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static Future<void> login(String login, String password) async {
    final data = await AuthApi.login(
      login: login,
      password: password,
    );

    await _storage.write(key: 'access_token', value: data['access_token']);
    await _storage.write(key: 'refresh_token', value: data['refresh_token']);
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: 'access_token');

  static Future<String?> getRefreshToken() =>
      _storage.read(key: 'refresh_token');

  static Future<void> logout() async {
    final refresh = await getRefreshToken();
    if (refresh != null) {
      await AuthApi.logout(refresh);
    }
    await _storage.deleteAll();
  }
}

