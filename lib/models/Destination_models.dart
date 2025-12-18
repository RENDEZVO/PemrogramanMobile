// lib/models/Destination_models.dart

class Destination {
  final String imageUrl;
  final String name;
  final String capital; // <-- Kita ganti 'location' jadi 'capital' biar jelas
  final double rating;
  final String category; 

  Destination({
    required this.imageUrl,
    required this.name,
    required this.capital, // <-- Update di constructor
    required this.rating,
    required this.category,
  });

  // Factory constructor untuk membaca JSON dari REST Countries API
  factory Destination.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? capitalList = json['capital'] as List<dynamic>?;
    
    return Destination(
      name: json['name']?['common'] ?? 'Unknown Country',
      
      // Ambil ibukota dari list API
      capital: (capitalList != null && capitalList.isNotEmpty) 
          ? capitalList.first as String 
          : 'No Capital',
      
      imageUrl: json['flags']?['png'] ?? '', 
      rating: 4.5, // Dummy rating
      category: json['region'] ?? 'Misc',
    );
  }
}

// Extension untuk Database SQLite
extension DestinationDbExtension on Destination {
  Map<String, dynamic> toMap() => {
        'name': name,
        'capital': capital, // <-- Simpan sebagai 'capital'
        'imageUrl': imageUrl,
        'rating': rating,
        'category': category,
      };

  static Destination fromDbMap(Map<String, dynamic> map) {
    return Destination(
      name: map['name'] as String,
      capital: map['capital'] as String, // <-- Baca sebagai 'capital'
      imageUrl: map['imageUrl'] as String,
      rating: map['rating'] as double,
      category: map['category'] as String,
    );
  }
}