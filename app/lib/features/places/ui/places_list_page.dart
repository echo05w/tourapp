import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../places/data/places_api.dart';
import '../../places/models/place.dart';
import 'place_details_page.dart';

class PlacesListPage extends StatefulWidget {
  const PlacesListPage({super.key});

  @override
  State<PlacesListPage> createState() => _PlacesListPageState();
}

class _PlacesListPageState extends State<PlacesListPage> {
  final api = PlacesApi();
  late Future<List<Place>> future;
  final ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    future = api.search(text: "Tashkent");
  }

  void _search() {
    setState(() {
      future = api.search(text: ctrl.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tour App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Search places (e.g., Samarkand)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _search, child: const Text('Search')),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Place>>(
              future: future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snap.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('No places found'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => PlaceDetailsPage(place: p))),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: p.imageUrl != null
                                ? CachedNetworkImage(imageUrl: p.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                                : Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.photo)))
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Text([p.city, p.country].where((e) => (e ?? '').isNotEmpty).join(', '),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
