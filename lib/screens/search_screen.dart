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
    final searchQuery = ref.watch(searchQueryProvider);
    final destinationsAsync = ref.watch(destinationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Cari berdasarkan nama...',
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      
      body: destinationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error memuat data: $err')),
        data: (allDestinations) {
          
          final List<Destination> results = searchQuery.isEmpty
              ? allDestinations
              : allDestinations
                  .where((dest) =>
                      dest.name.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();

          if (results.isEmpty) {
            return Center(child: Text(searchQuery.isEmpty ? 'Mulai ketik untuk mencari.' : 'Tidak ditemukan.', style: const TextStyle(fontSize: 16, color: Colors.grey)));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return DestinationCard(destination: results[index]);
            },
          );
        },
      ),
    );
  }
}