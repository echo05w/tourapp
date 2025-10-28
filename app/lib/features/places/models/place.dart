class Place {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final String? city;
  final String? country;
  final String? imageUrl;

  const Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.city,
    this.country,
    this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> j) {
    return Place(
      id: j['id'] ?? j['xid'] ?? '',
      name: j['name'] ?? 'Unknown',
      lat: (j['lat'] as num).toDouble(),
      lon: (j['lon'] as num).toDouble(),
      city: j['city'] as String?,
      country: j['country'] as String?,
      imageUrl: j['imageUrl'] as String?,
    );
  }
}
