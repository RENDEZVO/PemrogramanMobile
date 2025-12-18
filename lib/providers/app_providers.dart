import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:travelogue_app/helpers/database_helper.dart';
import 'package:travelogue_app/models/Destination_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _apiUrl = 'https://restcountries.com/v3.1/all?fields=name,capital,flags,region';

// Provider Fetch Data API
final destinationListProvider = FutureProvider<List<Destination>>((ref) async {
  final response = await http.get(Uri.parse(_apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Destination.fromJson(json)).toList();
  } else {
    throw Exception('Gagal memuat data negara');
  }
});

// Provider Kategori Pilihan
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'Asia'; 
});

// Provider Filter (sekarang memfilter berdasarkan benua/region)
final filteredDestinationsProvider = Provider<AsyncValue<List<Destination>>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final destinationsAsync = ref.watch(destinationListProvider);

  return destinationsAsync.whenData((destinations) {
    
    // === DEBUG PRINT ===
    print('--- MENJALANKAN FILTER ---');
    print('Kategori Dipilih: $selectedCategory');
    // ==================

    // Filter Case-Insensitive
    final lowerCaseSelectedCategory = selectedCategory.toLowerCase();
    return destinations
        .where((d) => d.category.toLowerCase() == lowerCaseSelectedCategory)
        .toList();
  });
});

// --- BAGIAN YANG DIPERBAIKI (FavoriteNotifier) ---
class FavoriteDestinationsNotifier extends StateNotifier<List<Destination>> {
  FavoriteDestinationsNotifier() : super([]) { _loadFavorites(); }

  Future<void> _loadFavorites() async {
    // FIX: Hapus .instance, ganti jadi DatabaseHelper()
    final favorites = await DatabaseHelper().getFavorites();
    state = favorites;
  }

  Future<void> toggleFavorite(Destination destination) async {
    final isCurrentlyFavorite = state.any((d) => d.name == destination.name);
    
    if (isCurrentlyFavorite) {
      // FIX: Hapus .instance, ganti jadi DatabaseHelper()
      await DatabaseHelper().removeFavorite(destination.name);
      state = state.where((d) => d.name != destination.name).toList();
    } else {
      // FIX: Hapus .instance, ganti jadi DatabaseHelper()
      await DatabaseHelper().addFavorite(destination);
      state = [...state, destination];
    }
  }
}

final favoriteDestinationsProvider =
    StateNotifierProvider<FavoriteDestinationsNotifier, List<Destination>>((ref) {
  return FavoriteDestinationsNotifier();
});

// Provider Tema (SharedPreferences)
class ThemeNotifier extends StateNotifier<ThemeMode> {
  late SharedPreferences _prefs;
  static const _themeKey = 'themeMode';
  
  ThemeNotifier() : super(ThemeMode.light) { _init(); }
  
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final themeString = _prefs.getString(_themeKey);
    state = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_themeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});