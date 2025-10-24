import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/models/Destination_models.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/widgets/Destination_card.dart';

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau query pencarian
    final searchQuery = ref.watch(searchQueryProvider);
    // Pantau data destinasi dari provider utama (yang hardcode)
    final allDestinations = ref.watch(destinationListProvider);

    // Filter data berdasarkan query
    final List<Destination> results = searchQuery.isEmpty
        ? allDestinations 
        : allDestinations
            .where((dest) =>
                dest.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        // TextField untuk input
        title: TextField(
          autofocus: true, // Langsung aktif saat halaman dibuka
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Cari nama destinasi...',
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none, // Hapus garis bawah
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          ),
          onChanged: (value) {
            // Update state pencarian saat user mengetik
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: results.isEmpty
          // Tampilkan pesan jika hasil kosong
          ? Center(
              child: Text(
                searchQuery.isEmpty
                    ? 'Mulai ketik untuk mencari.'
                    : 'Destinasi "$searchQuery" tidak ditemukan.',
                 style: const TextStyle(fontSize: 16, color: Colors.grey),
                 textAlign: TextAlign.center,
              ),
            )
          // Tampilkan hasil (bisa ListView atau GridView)
          : ListView.builder( // Kita pakai ListView dulu
              padding: const EdgeInsets.all(16.0),
              itemCount: results.length,
              itemBuilder: (context, index) {
                // Tampilkan kartu di dalam daftar
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DestinationCard(destination: results[index]),
                );
              },
            ),
    );
  }
}