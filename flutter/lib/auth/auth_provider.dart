import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'token_storage.dart';
import '../../graphql/graphql_service.dart';

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

  Future<String?> refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      await logout();
      return null;
    }
  
    try {
      final newAccessToken = await _authService.refreshToken(refreshToken);
  
      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
  
      _isAuthenticated = true;
      notifyListeners();
  
      return newAccessToken;
    } catch (_) {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      await _authService.logout(refreshToken);
    }

    await _tokenStorage.clear();
    GraphQLService().clearCache();
    _isAuthenticated = false;
    notifyListeners();
  }
}


































