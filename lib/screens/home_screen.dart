import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/widgets/Category_Selector.dart';
import 'package:travelogue_app/widgets/Destination_card.dart';
import 'package:travelogue_app/widgets/user_profile_dialog.dart';
import 'package:travelogue_app/screens/favorite_screen.dart';
import 'package:travelogue_app/screens/search_screen.dart';
import 'package:travelogue_app/screens/login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredDestinationsValue = ref.watch(filteredDestinationsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Discover', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 28)),
        actions: [
          IconButton(icon: Icon(Icons.login, color: Theme.of(context).colorScheme.primary), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),
          IconButton(icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()))),
          IconButton(icon: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteScreen()))),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => showDialog(context: context, builder: (context) => const UserProfileDialog()),
              child: const CircleAvatar(backgroundImage: AssetImage('assets/images/borobudur.jpg')),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("What you would like to find?", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          const SizedBox(height: 20),
          const CategorySelector(),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Popular Destinations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          const SizedBox(height: 20),

          // Tampilkan data API dengan .when()
          filteredDestinationsValue.when(
            data: (destinations) {
              if (destinations.isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: Text('Tidak ada destinasi untuk kategori ini.')));
              }
              return SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    
                    return Container(
                      width: 220, // Beri lebar tetap
                      margin: const EdgeInsets.only(left: 16), // Beri margin
                      child: DestinationCard(destination: destinations[index]),
                    );
            
                  },
                ),
              );
            },
            loading: () => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
            error: (error, stack) => SizedBox(height: 300, child: Center(child: Text('Gagal memuat data: ${error.toString()}'))),
          ),
        ],
      ),
    );
  }
}