import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:travelogue_app/models/Destination_models.dart';

class ApiService {
  final String _baseUrl = 'https://pixabay.com/api/';
  String? _apiKey;

  ApiService() {
    _apiKey = dotenv.env['PIXABAY_API_KEY']; 
    if (_apiKey == null) {
      print('KESALAHAN: PIXABAY_API_KEY tidak ditemukan di .env');
    }
  }

  // Fungsi untuk mengambil data destinasi
  Future<List<Destination>> fetchDestinations() async {
    if (_apiKey == null) {
      throw Exception('API Key Pixabay tidak ada');
    }

    final response = await http.get(
      Uri.parse('${_baseUrl}?key=$_apiKey&q=indonesia+travel&image_type=photo&per_page=30'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> hits = data['hits']; // Data Pixabay ada di 'hits'
      
      return hits.map((json) => Destination.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dari Pixabay: ${response.body}');
    }
  }
}