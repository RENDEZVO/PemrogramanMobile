import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:travelogue_app/models/Destination_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Constructor privat
  DatabaseHelper._init();

  // Getter untuk mengakses database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  // Inisialisasi Database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat tabel Favorit
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE favorites (
  id $idType,
  name $textType UNIQUE, 
  location $textType,
  imageUrl $textType,
  rating $doubleType,
  category $textType
)
''');
  }

  // Fungsi untuk menambahkan favorit
  Future<int> addFavorite(Destination destination) async {
    final db = await instance.database;
    // Menggunakan toMap() yang disediakan oleh Extension di Destination_models.dart
    return await db.insert('favorites', destination.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Fungsi untuk menghapus favorit
  Future<int> removeFavorite(String name) async {
    final db = await instance.database;
    return await db.delete(
      'favorites',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  // Fungsi untuk mendapatkan semua favorit
  Future<List<Destination>> getFavorites() async {
    final db = await instance.database;
    final maps = await db.query('favorites', orderBy: 'name ASC');

    if (maps.isNotEmpty) {
      // Menggunakan fromDbMap() dari Extension
      return maps.map((json) => DestinationDbExtension.fromDbMap(json)).toList();
    } else {
      return [];
    }
  }

  // Fungsi untuk menutup database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}