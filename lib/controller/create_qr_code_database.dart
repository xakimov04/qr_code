import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CreateQrCodeDatabase {
  static final CreateQrCodeDatabase _instance = CreateQrCodeDatabase._internal();
  factory CreateQrCodeDatabase() => _instance;

  CreateQrCodeDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'create_qr_codes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE create_qr_codes('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'code TEXT NOT NULL, '
          'date TEXT NOT NULL, '
          'time TEXT NOT NULL)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS create_qr_codes');
        await db.execute(
          'CREATE TABLE create_qr_codes('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'code TEXT NOT NULL, '
          'date TEXT NOT NULL, '
          'time TEXT NOT NULL)',
        );
      },
    );
  }

  Future<void> insertQRCode(String code, String date, String time) async {
    final db = await database;
    await db.insert(
      'create_qr_codes',
      {'code': code, 'date': date, 'time': time},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getQRCodes() async {
    final db = await database;
    return await db.query('create_qr_codes');
  }

  Future<void> deleteQRCode(int id) async {
    final db = await database;
    await db.delete(
      'create_qr_codes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
