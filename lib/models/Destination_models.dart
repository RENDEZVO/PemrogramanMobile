// lib/models/Destination_models.dart

class Destination {
  final String imageUrl;
  final String name;
  final String location;
  final double rating;
  final String category;

  Destination({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.rating,
    required this.category,
  });
}

// ===== EXTENSION UNTUK DATABASE (HARUS ADA DI SINI) =====
// Menambahkan method toMap dan fromDbMap

extension DestinationDbExtension on Destination {
  // Method untuk mengubah objek Destination MENJADI Map
  Map<String, dynamic> toMap() => {
        'name': name,
        'location': location,
        'imageUrl': imageUrl,
        'rating': rating,
        'category': category,
      };

  // Method static untuk membuat objek Destination DARI Map
  static Destination fromDbMap(Map<String, dynamic> map) {
    return Destination(
      name: map['name'] as String,
      location: map['location'] as String,
      imageUrl: map['imageUrl'] as String,
      rating: map['rating'] as double,
      category: map['category'] as String,
    );
  }
}