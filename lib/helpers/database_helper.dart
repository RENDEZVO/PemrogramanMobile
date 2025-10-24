// lib/helpers/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:travelogue_app/models/Destination_models.dart'; // Pastikan import model

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // ... (kode create table tidak berubah)
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    await db.execute('''
CREATE TABLE favorites (
  id $idType, name $textType UNIQUE, location $textType,
  imageUrl $textType, rating $doubleType, category $textType
)
''');
  }

  // Fungsi addFavorite memanggil destination.toMap()
  Future<int> addFavorite(Destination destination) async {
    final db = await instance.database;
    return await db.insert('favorites', destination.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Fungsi removeFavorite (tidak berubah)
  Future<int> removeFavorite(String name) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'name = ?', whereArgs: [name]);
  }

  // Fungsi getFavorites memanggil DestinationDbExtension.fromDbMap
  Future<List<Destination>> getFavorites() async {
    final db = await instance.database;
    final maps = await db.query('favorites', orderBy: 'name ASC');

    if (maps.isNotEmpty) {
      // Panggil static method dari extension
      return maps.map((json) => DestinationDbExtension.fromDbMap(json)).toList();
    } else {
      return [];
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}