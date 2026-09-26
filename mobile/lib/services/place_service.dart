import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class PlaceService {
  static const String baseUrl = AuthService.baseUrl;

  final AuthService _authService = AuthService();

  Future<List<Map<String, dynamic>>> getPlaces() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/places/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Não foi possível carregar os locais.',
      );
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      throw Exception(
        'Resposta inválida da API.',
      );
    }

    return data
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>> createPlace({
    required String name,
    required bool hasElevator,
    required bool highMovement,
    required bool strongLights,
  }) async {
    final token = await _authService.getAccessToken();

    if (token == null) {
      throw Exception(
        'Você precisa estar autenticado.',
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/places/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'has_elevator': hasElevator,
        'high_movement': highMovement,
        'strong_lights': strongLights,
      }),
    );

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
  }
}