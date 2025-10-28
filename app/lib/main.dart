import 'package:flutter/material.dart';
import 'features/places/ui/places_list_page.dart';

void main() {
  runApp(const TourApp());
}

class TourApp extends StatelessWidget {
  const TourApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A6EF0), brightness: Brightness.light),
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'Tour App',
      theme: theme,
      home: const PlacesListPage(),
    );
  }
}
