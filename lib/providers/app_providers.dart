import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/models/Destination_models.dart';

// ===== 1. Provider Kembali ke Data Hardcode =====
final destinationListProvider = Provider<List<Destination>>((ref) {
  return [
    Destination(
      imageUrl: 'assets/images/nusa_penida.jpg',
      name: 'Nusa Penida',
      location: 'Bali, Indonesia',
      rating: 4.8,
      category: 'Beach',
    ),
    Destination(
      imageUrl: 'assets/images/bromo.jpg',
      name: 'Gunung Bromo',
      location: 'Jawa Timur, Indonesia',
      rating: 4.9,
      category: 'Mountain',
    ),
    Destination(
      imageUrl: 'assets/images/borobudur.jpg',
      name: 'Candi Borobudur',
      location: 'Jawa Tengah, Indonesia',
      rating: 4.7,
      category: 'Culture',
    ),
    Destination(
      imageUrl: 'assets/images/jakarta.jpeg',
      name: 'Kota Jakarta',
      location: 'DKI Jakarta, Indonesia',
      rating: 4.6,
      category: 'City',
    ),
  ];
});

// ===== 2. Provider Kategori (Tidak Berubah) =====
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'Beach';
});

// ===== 3. Provider Filter (Kembali ke Versi Simpel) =====
final filteredDestinationsProvider = Provider<List<Destination>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  // Langsung ambil data dari provider hardcode
  final allDestinations = ref.watch(destinationListProvider);

  // Filter seperti biasa
  return allDestinations
      .where((destination) => destination.category == selectedCategory)
      .toList();
});

// ===== 4. Provider Favorit (Tidak Berubah) =====
class FavoriteDestinationsNotifier extends StateNotifier<List<Destination>> {
  FavoriteDestinationsNotifier() : super([]);
  void toggleFavorite(Destination destination) {
    if (state.contains(destination)) {
      state = state.where((d) => d.name != destination.name).toList();
    } else {
      state = [...state, destination];
    }
  }
}
final favoriteDestinationsProvider =
    StateNotifierProvider<FavoriteDestinationsNotifier, List<Destination>>((ref) {
  return FavoriteDestinationsNotifier();
});

// ===== 5. Provider Tema (Tidak Berubah) =====
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});