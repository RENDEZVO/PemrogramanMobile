import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/widgets/Destination_card.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteDestinations = ref.watch(favoriteDestinationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinasi Favorit'),
        backgroundColor: Colors.transparent, 
        elevation: 0,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      body: favoriteDestinations.isEmpty
          // Jika tidak ada favorit, tampilkan pesan
          ? const Center(
              child: Text(
                'Belum ada destinasi favorit.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          // Jika ada favorit, tampilkan dalam ListView
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              itemCount: favoriteDestinations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                
                  child: DestinationCard(
                    destination: favoriteDestinations[index],
                  
                  ),
                );
              },
            ),
    );
  }
}