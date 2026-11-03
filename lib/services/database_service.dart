
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/air_quality_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  // Membuka database atau membuatnya jika belum tersedia.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('airy.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Membuat tabel riwayat kualitas udara.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE air_quality_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_name TEXT NOT NULL,
        time TEXT NOT NULL,
        us_aqi REAL,
        pm25 REAL,
        pm10 REAL,
        carbon_monoxide REAL,
        nitrogen_dioxide REAL,
        sulphur_dioxide REAL,
        ozone REAL,
        UNIQUE(city_name, time)
      )
    ''');
  }

  // Menyimpan data kualitas udara.
  Future<int> saveAirQuality(
      String cityName,
      AirQualityModel airQuality,
      ) async {
    final db = await database;

    final data = airQuality.toMap();
    data['city_name'] = cityName;

    return await db.insert(
      'air_quality_history',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mengambil seluruh riwayat kualitas udara.
  Future<List<Map<String, dynamic>>> getHistory({
    String? cityName,
  }) async {
    final db = await database;

    return await db.query(
      'air_quality_history',
      where: cityName != null ? 'city_name = ?' : null,
      whereArgs: cityName != null ? [cityName] : null,
      orderBy: 'time DESC',
    );
  }

  // Menghapus satu riwayat.
  Future<int> deleteHistory(int id) async {
    final db = await database;

    return await db.delete(
      'air_quality_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus seluruh riwayat.
  Future<int> clearHistory() async {
    final db = await database;

    return await db.delete('air_quality_history');
  }
}
