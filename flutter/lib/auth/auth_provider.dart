import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'auth_state.dart';
import 'token_storage.dart';
import '../../graphql/graphql_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();
  final _tokenStorage = TokenStorage();
  AuthStatus status = AuthStatus.unknown;

  Future<void> init() async {
    TokenStorage.onAuthStateChanged = checkAuthStatus;
    await _tokenStorage.init();

    status = _tokenStorage.accessToken == null
      ? AuthStatus.unauthenticated
      : AuthStatus.authenticated;

    notifyListeners(); 
  }

  void checkAuthStatus() {
    final tokenStorage = TokenStorage();
    if (tokenStorage.accessToken != null) {
      status = AuthStatus.authenticated;
    } else {
      status = AuthStatus.unauthenticated;
    }
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

    status = AuthStatus.authenticated;
    notifyListeners();
  }


  Future<void> changePassword(String email, String currentPassword, String newPassword) async {
    await _authService.changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    //await _tokenStorage.saveTokens(
    //  accessToken: result['access_token'],
    //  refreshToken: result['refresh_token'],
    //);

    //status = AuthStatus.authenticated;
    //notifyListeners();
  }

  Future<void> logout() async {
    final refreshToken = _tokenStorage.refreshToken;
    if (refreshToken != null) {
      await _authService.logout(refreshToken);
    }

    await _tokenStorage.clear();
    GraphQLService().clearCache();
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}


































