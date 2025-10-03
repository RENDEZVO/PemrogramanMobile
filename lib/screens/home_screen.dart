import 'package:flutter/material.dart';
import 'package:travelogue_app/models/Destination_models.dart'; 
import 'package:travelogue_app/widgets/Destination_card.dart';
import 'package:travelogue_app/widgets/Cattegory_Selector.dart';


class HomeScreen extends StatelessWidget {
  final List<Destination> destinations = [
    Destination(
      imageUrl: 'assets/images/nusa_penida.jpg',
      name: 'Nusa Penida',
      location: 'Bali, Indonesia',
      rating: 4.8,
    ),
    Destination(
      imageUrl: 'assets/images/bromo.jpg',
      name: 'Gunung Bromo',
      location: 'Jawa Timur, Indonesia',
      rating: 4.9,
    ),
    Destination(
      imageUrl: 'assets/images/borobudur.jpg',
      name: 'Candi Borobudur',
      location: 'Jawa Tengah, Indonesia',
      rating: 4.7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Discover',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
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
          SizedBox(height: 20),
          CategorySelector(),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Popular Destinations",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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