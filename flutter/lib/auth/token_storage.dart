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
	final newAccessToken = await authService.getRefreshToken(_refreshToken!);
	_accessToken = newAccessToken;
	if (newAccessToken != null) {
      	  _accessToken = newAccessToken;
      	  await _storage.write(key: 'access_token', value: newAccessToken);
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

  bool _isAccessTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );

    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch / 1000;

    return exp == null || now >= exp;
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
