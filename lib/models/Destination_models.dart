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

  // Factory constructor untuk membaca JSON dari REST Countries API
  factory Destination.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? capitalList = json['capital'] as List<dynamic>?;
    
    return Destination(
      name: json['name']?['common'] ?? 'Unknown Country',
      
      location: (capitalList != null && capitalList.isNotEmpty) 
          ? capitalList.first as String 
          : 'No Capital',
      
      imageUrl: json['flags']?['png'] ?? '', 
      rating: 4.5,
      category: json['region'] ?? 'Misc',
    );
  }
}

extension DestinationDbExtension on Destination {
  Map<String, dynamic> toMap() => {
        'name': name,
        'location': location,
        'imageUrl': imageUrl,
        'rating': rating,
        'category': category,
      };

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