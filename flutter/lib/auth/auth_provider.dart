import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'token_storage.dart';
import 'package:provider/provider.dart';

final AuthProvider authProvider = AuthProvider();

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();
  final _tokenStorage = TokenStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    final token = await _tokenStorage.getAccessToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final result = await _authService.login(
      email: email,
      password: password,
    );

    await _tokenStorage.saveTokens(
      accessToken: result['access_token'],
      refreshToken: result['refresh_token'],
    );

    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      await _authService.logout(refreshToken);
    }

    await _tokenStorage.clear();
    _isAuthenticated = false;
    notifyListeners();
  }
}


































