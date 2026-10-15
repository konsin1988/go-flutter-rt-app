import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import './auth_service.dart';

final authService = AuthService();

class TokenStorage {
  
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;

  TokenStorage._internal();
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static VoidCallback? onAuthStateChanged;

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> init() async {
    _accessToken = await _storage.read(key: 'access_token');
    _refreshToken = await _storage.read(key: 'refresh_token');
    
    if (_accessToken == null && _refreshToken == null) {
      return;
    }

    if (_accessToken != null && !_isAccessTokenExpired(_accessToken!)){
      return;
    }

    if (_refreshToken != null) {
      try {
	      final result = await authService.getRefreshToken(_refreshToken!);
        final newAccessToken = result['access_token'] as String?;
        final newRefreshToken = result['refresh_token'] as String?;

        if (newAccessToken != null) {
          await saveTokens(
            accessToken: newAccessToken,
            // Keep the existing refresh token if the server doesn't return a new one.
            refreshToken: newRefreshToken ?? _refreshToken!,
          );
          return;
        }
      } catch (e) {
	      _accessToken = null;
	      _refreshToken = null;
	      await clear();
	      onAuthStateChanged?.call();
      }

    }
    await clear();
    onAuthStateChanged?.call();
  }

  Future<String?> getValidAccessToken() async {
    if (_accessToken == null) {
      return null;
    }
  
    if (!_isAccessTokenExpired(_accessToken!)) {
      return _accessToken;
    }
  
    final refreshed = await refreshAccessToken();
  
    if (!refreshed || _accessToken == null) {
      throw Exception('Unable to refresh access token');
    }
  
    return _accessToken;
  }

  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) {
      return false;
    }
  
    try {
      final result = await authService.getRefreshToken(_refreshToken!);
  
      final newAccessToken = result['access_token'] as String?;
      final newRefreshToken = result['refresh_token'] as String?;
  
      if (newAccessToken == null) {
        return false;
      }
  
      await saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? _refreshToken!,
      );
  
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isAccessTokenExpired(
    String token, {
    Duration buffer = const Duration(seconds: 30),
  }) {
    try {
      final parts = token.split('.');
  
      if (parts.length != 3) {
        return true;
      }
  
      final payload = json.decode(
        utf8.decode(
          base64Url.decode(
            base64Url.normalize(parts[1]),
          ),
        ),
      );
  
      if (payload is! Map<String, dynamic>) {
        return true;
      }
  
      final exp = payload['exp'];
  
      if (exp is! num) {
        return true;
      }
  
      final expiration = DateTime.fromMillisecondsSinceEpoch(
        (exp * 1000).round(),
      );
  
      return !expiration.isAfter(
        DateTime.now().add(buffer),
      );
    } catch (_) {
      // A malformed or undecodable token must not be treated as valid.
      return true;
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  } 

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;

    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
