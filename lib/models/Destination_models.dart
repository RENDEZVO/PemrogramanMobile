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

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] ?? 'No Name',
      location: json['location'] ?? 'No Location',
      imageUrl: json['image_Url'] ?? '',
      rating: (json['rating'] ?? 00).toDouble(),
      category: json['category'] ?? 'Misc',
    );
  } 
}