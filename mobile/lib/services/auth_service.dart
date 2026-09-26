import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService {

  // Dont use localhost in your phone
  // The mobile phone needs to access the IP address of the machine where Django is running.

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

  // Register method

  Future<Map<String, dynamic>> register({

    required String email,

    required String name,

    required int age,

    required bool mobility,

    required bool speaks,

    required bool sensorySensitivity,

    required String password,

  }) async {

    try {

      final response = await http.post(

        Uri.parse('$baseUrl/api/auth/register/'),

        headers: {

          'Content-Type': 'application/json',

        },

        body: jsonEncode({

          'email': email,

          'name': name,

          'age': age,

          'mobility': mobility,

          'speaks': speaks,

          'sensory_sensitivity': sensorySensitivity,

          'password': password,

        }),

      );
      //Only for debug
      print('========== REGISTER API =========='); 

      print('URL: $baseUrl/api/auth/register/');

      print('Status: ${response.statusCode}');

      print('Resposta: ${response.body}');

      print('==================================');

      dynamic data;

      try {

        data = jsonDecode(response.body);

      } catch (_) {

        data = {

          'message': response.body,

        };

      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {

        return {

          'success': true,

          'statusCode': response.statusCode,

          'data': data,

        };

      }

      return {

        'success': false,

        'statusCode': response.statusCode,

        'data': data,

      };

    } catch (e) {

      print('========== ERRO REGISTER ==========');

      print(e);

      print('===================================');

      return {

        'success': false,

        'statusCode': 0,

        'data': {

          'error': e.toString(),

        },

      };

    }

  }

  Future<String?> getAccessToken() async {

    return _storage.read(key: _accessTokenKey);

  }

  Future<String?> getRefreshToken() async {

    return _storage.read(key: _refreshTokenKey);

  }

  Future<Map<String, dynamic>?> getMe() async { //Get own user logged in information

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


  Future<Map<String, dynamic>> updateProfile({
  required String name,
  required String email,
  required bool mobility,
  required bool speaks,
  required bool sensorySensitivity,
}) async {
  final token = await getAccessToken();

  if (token == null) {
    return {
      'success': false,
      'statusCode': 401,
      'data': {
        'detail': 'Você precisa estar autenticado.',
      },
    };
  }

  try {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/auth/me/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'mobility': mobility,
        'speaks': speaks,
        'sensory_sensitivity': sensorySensitivity,
      }),
    );

    print('========== UPDATE PROFILE ==========');
    print('URL: $baseUrl/api/auth/me/');
    print('Status: ${response.statusCode}');
    print('Resposta: ${response.body}');
    print('====================================');

    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = {
        'message': response.body,
      };
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return {
        'success': true,
        'statusCode': response.statusCode,
        'data': data,
      };
    }

    return {
      'success': false,
      'statusCode': response.statusCode,
      'data': data,
    };
  } catch (e) {
    print('========== ERRO UPDATE PROFILE ==========');
    print(e);
    print('=========================================');

    return {
      'success': false,
      'statusCode': 0,
      'data': {
        'error': e.toString(),
      },
    };
  }
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