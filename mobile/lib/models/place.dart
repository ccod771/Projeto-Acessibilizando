class Place {
  final int id;
  final String googlePlaceId;
  final String name;
  final double latitude;
  final double longitude;
  final double? averageRating;
  final int reviewCount;

  Place({
    required this.id,
    required this.googlePlaceId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.averageRating,
    required this.reviewCount,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      googlePlaceId: json['google_place_id'] as String,
      name: json['name'] as String,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      averageRating: json['average_rating'] != null
          ? double.parse(json['average_rating'].toString())
          : null,
      reviewCount: json['review_count'] as int? ?? 0,
    );
  }
}