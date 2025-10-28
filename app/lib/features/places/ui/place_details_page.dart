import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../places/models/place.dart';
import '../../places/data/places_api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlaceDetailsPage extends StatefulWidget {
  final Place place;
  const PlaceDetailsPage({super.key, required this.place});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  final api = PlacesApi();
  String? heroImage;

  @override
  void initState() {
    super.initState();
    _loadHero();
  }

  Future<void> _loadHero() async {
    final q = '${widget.place.name} ${widget.place.city ?? ''}';
    final imgs = await api.images(q);
    setState(() => heroImage = imgs.isNotEmpty ? imgs.first : widget.place.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: heroImage != null
              ? CachedNetworkImage(imageUrl: heroImage!, fit: BoxFit.cover)
              : Container(color: Colors.grey.shade300),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text([p.city, p.country].where((e) => (e ?? '').isNotEmpty).join(', ')),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(initialCenter: LatLng(p.lat, p.lon), initialZoom: 13),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a','b','c'],
                      userAgentPackageName: 'com.example.tour_app',
                    ),
                    MarkerLayer(markers: [
                      Marker(point: LatLng(p.lat, p.lon), width: 40, height: 40,
                        child: const Icon(Icons.location_pin, size: 36))
                    ])
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

