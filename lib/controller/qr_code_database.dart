import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'qr_codes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE qr_codes(id INTEGER PRIMARY KEY, code TEXT, date TEXT, time TEXT)',
        );
      },
    );
  }

  Future<void> insertQRCode(String code, String date, String time) async {
    final db = await database;
    await db.insert(
      'qr_codes',
      {'code': code, 'date': date, 'time': time},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getQRCodes() async {
    final db = await database;
    return await db.query('qr_codes');
  }

  Future<void> deleteQRCode(int id) async {
    final db = await database;
    await db.delete(
      'qr_codes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
