import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';

class AuthService {
  static const String baseURL = AppLinks.baseURL; 

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
	'email': email,
	'password': password,
      }),
    );

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/change_pass'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
	'email': email,
	'current_password': currentPassword,
  'new_password': newPassword,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
      'Failed to change password: ${response.statusCode}',
      );
    }
  }
  
  Future<String> getRefreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
	'refresh_token': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Token refresh failed');
    }
  }

  Future<void> logout(String refreshToken) async {
    await http.post(
      Uri.parse('$baseURL/auth/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
	'refresh_token': refreshToken,
      }),
    );
  }
}






























