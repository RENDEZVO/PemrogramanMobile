import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/models/Destination_models.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/screens/detail_screen.dart'; // Pastikan Import ini ada

class DestinationCard extends ConsumerWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau status favorit
    final favoriteDestinations = ref.watch(favoriteDestinationsProvider);
    final isFavorite = favoriteDestinations.any((d) => d.name == destination.name);

    return InkWell(
      onTap: () {
        // --- PERBAIKAN DI SINI ---
        // Navigasi ke Halaman Detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(destination: destination),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            // 1. GAMBAR UTAMA
            Hero( // Tambahan Hero biar animasi terbang
              tag: destination.name, 
              child: Image.network(
                destination.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                  );
                },
              ),
            ),

            // 2. GRADASI HITAM (Biar tulisan terbaca)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),

            // 3. TEKS INFORMASI
            Positioned(
              bottom: 8, left: 8, right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 10),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          destination.capital, // Sudah benar pakai capital
                          style: const TextStyle(color: Colors.white70, fontSize: 9),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 4. TOMBOL FAVORIT
            Positioned(
              top: 4, left: 4,
              child: CircleAvatar( // Tambah background dikit biar kelihatan
                backgroundColor: Colors.black26,
                radius: 14,
                child: IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                     // Panggil Provider untuk simpan/hapus
                     ref.read(favoriteDestinationsProvider.notifier).toggleFavorite(destination);
                  },
                ),
              ),
            ),

            // 5. RATING BADGE
            Positioned(
              top: 6, right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.star, color: Colors.amber, size: 10), 
                  const SizedBox(width: 2),
                  Text(destination.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}