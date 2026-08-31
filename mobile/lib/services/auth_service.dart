import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // No celular físico, NÃO use localhost.
  // O celular precisa acessar o IP da máquina onde o Django está rodando.
  static const String baseUrl = 'http://192.168.1.66:8000';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final data = jsonDecode(response.body);

    await _storage.write(
      key: _accessTokenKey,
      value: data['access'],
    );

    await _storage.write(
      key: _refreshTokenKey,
      value: data['refresh'],
    );

    return true;
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<Map<String, dynamic>?> getMe() async {
    final token = await getAccessToken();

    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/me/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    return jsonDecode(response.body);
  }

  Future<void> logout() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();

    return token != null;
  }
}
