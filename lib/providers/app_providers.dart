import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/models/Destination_models.dart';

// ===== 1. Provider untuk Daftar Destinasi LENGKAP =====
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

// ===== Provider BARU untuk Daftar Destinasi yang SUDAH DIFILTER =====
// Ini adalah bagian yang ditambahkan
final filteredDestinationsProvider = Provider<List<Destination>>((ref) {
  // Provider ini "mendengarkan" dua provider lain:
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final allDestinations = ref.watch(destinationListProvider);

  // Kemudian, ia mengembalikan daftar baru berdasarkan filter
  return allDestinations
      .where((destination) => destination.category == selectedCategory)
      .toList();
});


// ===== 2. Provider untuk Kategori yang Dipilih =====
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'Beach'; // Nilai awal
});


// ===== 3. Provider untuk Destinasi Favorit =====
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