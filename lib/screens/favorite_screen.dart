import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/widgets/Destination_card.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Langsung pantau provider. Hasilnya adalah List<Destination>.
    final favoriteDestinations = ref.watch(favoriteDestinationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinasi Favorit'),
        // ... (styling AppBar)
      ),
      // 2. Tidak perlu .when(), langsung cek isEmpty
      body: favoriteDestinations.isEmpty
          ? const Center(
              child: Text('Belum ada destinasi favorit.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteDestinations.length,
              itemBuilder: (context, index) {
                return DestinationCard(destination: favoriteDestinations[index]);
              },
            ),
    );
  }
}