import 'package:flutter/material.dart';
import 'package:travelogue_app/models/Destination_models.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    // 1. Dibungkus dengan InkWell agar bisa di-tap
    return InkWell(
      // 2. Properti onTap untuk aksi saat disentuh
      onTap: () {
  // 1. Membuat widget SnackBar
  final snackBar = SnackBar(
    content: Text('Anda memilih ${destination.name}'), // Teks yang akan ditampilkan
    backgroundColor: Colors.blueAccent, // Ganti warna latar belakang (opsional)
    action: SnackBarAction(
      label: 'Tutup', // Teks untuk tombol aksi (opsional)
      textColor: Colors.white,
      onPressed: () {
        // Kode ini akan dijalankan jika tombol "Tutup" ditekan
      },
    ),
  );

  // 2. Menampilkan SnackBar menggunakan ScaffoldMessenger
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        width: 220,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                destination.imageUrl,
                height: 300,
                width: 220,
                fit: BoxFit.cover,
              ),
            ),
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
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
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
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
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
            )
          ],
        ),
      ),
    );
  }
}