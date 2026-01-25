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
      headers: {'Content-Type': 'application/json'},
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
  
  Future<String> refreshToken(String refreshToken) async {
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






























