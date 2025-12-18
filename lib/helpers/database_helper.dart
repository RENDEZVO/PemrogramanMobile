import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:travelogue_app/models/Destination_models.dart'; // Pastikan import model yang benar

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'travelogue_favorites.db');
    return await openDatabase(
      path,
      version: 2, // Ganti versi jadi 2 biar fresh (opsional, tapi good practice)
      onCreate: (db, version) async {
        // --- PERHATIKAN BAGIAN INI ---
        // Kita ganti 'location' menjadi 'capital' di perintah SQL ini
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            capital TEXT, 
            imageUrl TEXT,
            rating REAL,
            category TEXT
          )
        ''');
      },
      // Tambahkan onUpgrade untuk jaga-jaga ke depannya
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("DROP TABLE IF EXISTS favorites");
          await _onCreate(db, newVersion);
        }
      },
    );
  }

  // Helper untuk create table ulang (dipanggil di onUpgrade)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        capital TEXT,
        imageUrl TEXT,
        rating REAL,
        category TEXT
      )
    ''');
  }

  Future<void> addFavorite(Destination destination) async {
    final db = await database;
    // insert conflictAlgorithm replace biar gak ada data ganda
    await db.insert(
      'favorites',
      destination.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String name) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Destination>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return DestinationDbExtension.fromDbMap(maps[i]);
    });
  }
}