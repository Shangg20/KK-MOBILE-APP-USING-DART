import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'kk_profiling.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profiling (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT,
            middle_name TEXT,
            last_name TEXT,
            age INTEGER,
            birthdate TEXT,
            email TEXT,
            contact_number TEXT,
            sex TEXT,
            civil_status TEXT,
            educational_background TEXT,
            region TEXT,
            province TEXT,
            municipality TEXT,
            barangay TEXT,
            purok TEXT,
            youth_classification TEXT,
            youth_age_group TEXT,
            specific_needs TEXT,
            working_status TEXT,
            is_sk_voter INTEGER,
            is_regular_voter INTEGER,
            times_attended INTEGER,
            is_synced INTEGER DEFAULT 0,
            date_added TEXT
          )
        ''');
      },
    );
  }

  // --- NEW: SAVE DATA FROM FORM ---
  Future<int> insertProfiling(Map<String, dynamic> data) async {
    final db = await database;
    // Add timestamp before saving
    data['date_added'] = DateTime.now().toIso8601String();
    data['is_synced'] = 0; 
    return await db.insert('profiling', data);
  }

  // --- NEW: FETCH FOR AUTO-SYNC ---
  Future<List<Map<String, dynamic>>> getUnsyncedData() async {
    final db = await database;
    return await db.query('profiling', where: 'is_synced = ?', whereArgs: [0]);
  }

  // --- NEW: MARK AS SYNCED ---
  Future<int> markAsSynced(int id) async {
    final db = await database;
    return await db.update(
      'profiling',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}