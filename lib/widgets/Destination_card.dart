import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/models/Destination_models.dart';
import 'package:travelogue_app/providers/app_providers.dart';

class DestinationCard extends ConsumerWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca daftar favorit dari provider
    final favoriteDestinations = ref.watch(favoriteDestinationsProvider);
    final isFavorite = favoriteDestinations.contains(destination);

    return InkWell(
      onTap: () {
        // Aksi SnackBar saat kartu ditekan
        final snackBar = SnackBar(content: Text('Anda memilih ${destination.name}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        width: 220,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Kode gambar dan teks tidak berubah
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                destination.imageUrl,
                height: 300,
                width: 220,
                fit: BoxFit.cover,
              ),
            ),
            // ... (Kode Container gradien dan Positioned untuk teks tetap sama)
            Container(
              height: 100,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        destination.location,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      destination.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // ===================================================
            // BAGIAN INI YANG MENAMPILKAN IKON HATI
            // ===================================================
            Positioned(
              top: 2,
              left: 2,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                  size: 30,
                ),
                onPressed: () {
                  ref
                      .read(favoriteDestinationsProvider.notifier)
                      .toggleFavorite(destination);
                },
              ),
            ),
            // ===================================================
          ],
        ),
      ),
    );
  }
}