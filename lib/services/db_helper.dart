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
    // This is where you use the 'path' import!
    String path = join(await getDatabasesPath(), 'kk_profiling.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profiling (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            -- Matches ProfilingInformations
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
            
            -- Matches KKAddress
            region TEXT,
            province TEXT,
            municipality TEXT,
            barangay TEXT,
            
            -- Matches YouthStatus
            youth_classification TEXT,
            youth_age_group TEXT,
            specific_needs TEXT,
            working_status TEXT,
            is_sk_voter INTEGER, -- SQLite uses 0/1 for Boolean
            is_regular_voter INTEGER,
            times_attended INTEGER,
            
            -- Integration Meta
            is_synced INTEGER DEFAULT 0,
            date_added TEXT
          )
        ''');
      },
    );
  }
}