import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/place.dart';


class PlaceRepository {
  final ApiClient apiClient;

  PlaceRepository({
    required this.apiClient,
  });

  Future<List<Place>> getPlaces() async {
    final Response response = await apiClient.dio.get(
      '/places/',
    );

    final List<dynamic> data = response.data;

    return data
        .map(
          (json) => Place.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}