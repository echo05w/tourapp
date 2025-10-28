import 'package:dio/dio.dart';
import '../../../core/env.dart';
import '../models/place.dart';

class PlacesApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<List<Place>> search({String? text, double? lat, double? lon, int limit = 12}) async {
    try {
      final res = await _dio.get(
        '/api/places/search',
        queryParameters: {
          if (text != null && text.isNotEmpty) 'text': text,
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
          'limit': limit,
        },
      );
      final data = res.data;
      if (data is List) {
        return data.map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List).map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // fall through to mock
    }
    final mock = await _dio.get('/api/mock/places');
    final list = (mock.data['data'] as List).map((e) => Place.fromJson(e)).toList();
    return list;
  }

  Future<List<String>> images(String q, {int limit = 6}) async {
    final res = await _dio.get('/api/images/search', queryParameters: {'q': q, 'limit': limit});
    final d = res.data;
    if (d is Map && d['data'] is List) {
      return (d['data'] as List).cast<String>();
    }
    return [];
  }
}
