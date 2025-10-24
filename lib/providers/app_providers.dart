import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelogue_app/helpers/database_helper.dart';
import 'package:travelogue_app/models/Destination_models.dart';

// ===== 1. Provider Kembali ke Data Hardcode (Tidak Berubah) =====
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

// ===== 3. Provider Filter (Tidak Berubah) =====
final filteredDestinationsProvider = Provider<List<Destination>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final allDestinations = ref.watch(destinationListProvider);

  return allDestinations
      .where((destination) => destination.category == selectedCategory)
      .toList();
});

// ===== Provider untuk Destinasi Favorit (dengan sqflite) =====
final favoriteDestinationsProvider =
    StateNotifierProvider<FavoriteDestinationsNotifier, List<Destination>>((ref) {
  return FavoriteDestinationsNotifier(); // Langsung return, inisialisasi di constructor
});

class FavoriteDestinationsNotifier extends StateNotifier<List<Destination>> {
  FavoriteDestinationsNotifier() : super([]) { // Nilai awal kosong sementara
    _loadFavorites(); // Panggil fungsi load saat dibuat
  }

  // Fungsi untuk load data dari DB
  Future<void> _loadFavorites() async {
    final favorites = await DatabaseHelper.instance.getFavorites();
    state = favorites; // Update state dengan data dari DB
  }

  // Fungsi untuk toggle favorit (menambah/menghapus)
  Future<void> toggleFavorite(Destination destination) async {
    // Cek state saat ini
    final isCurrentlyFavorite = state.any((d) => d.name == destination.name);

    if (isCurrentlyFavorite) {
      // Hapus dari DB
      await DatabaseHelper.instance.removeFavorite(destination.name);
      // Update state
      state = state.where((d) => d.name != destination.name).toList();
    } else {
      // Tambah ke DB
      await DatabaseHelper.instance.addFavorite(destination);
      // Update state
      state = [...state, destination];
    }
  }
}

// ===== 5. Provider Tema (Diubah untuk SharedPreferences) =====
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  late SharedPreferences _prefs;
  static const _themeKey = 'themeMode';

  ThemeNotifier() : super(ThemeMode.light) { // Default initial state
    _init(); // Call initialization
  }

  // Initialize and load the saved theme preference
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final themeString = _prefs.getString(_themeKey);
    if (themeString == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light; // Default to light if nothing is saved or it's 'light'
    }
  }

  // Change the theme and save the preference
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}