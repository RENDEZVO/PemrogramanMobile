import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Pastikan Riverpod di-import
import 'package:travelogue_app/providers/app_providers.dart'; // 2. Import file provider Anda
import 'package:travelogue_app/widgets/Category_Selector.dart'; // Koreksi typo jika perlu
import 'package:travelogue_app/widgets/Destination_card.dart';

// 3. Ubah dari StatelessWidget menjadi ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // 4. Hapus daftar destinasi dari sini, karena sudah dipindahkan ke provider
  // final List<Destination> destinations = [ ... ]; // <-- HAPUS BAGIAN INI

  @override
  // 5. Tambahkan 'WidgetRef ref' pada method build
  Widget build(BuildContext context, WidgetRef ref) {
    // 6. Ambil (watch) data dari provider
      final destinations = ref.watch(filteredDestinationsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "What you would like to find?",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CategorySelector(), // Widget ini juga akan kita ubah nanti
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Popular Destinations",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // 7. Gunakan 'destinations' yang sudah diambil dari provider
              itemCount: destinations.length,
              itemBuilder: (BuildContext context, int index) {
                return DestinationCard(destination: destinations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}