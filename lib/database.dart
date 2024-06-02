import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// define class DatabaseHelper
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  // main rendering table defining
  static const String tableName = 'everyday';

  static const String columnNumber = 'number';
  static const String columnTitle = 'title';
  static const String columnTimeStamp = 'timeStamp';

  // store notifications table defining
  static const String secondTableName = 'plan';

  static const String secondColumnCode = 'codeSaved';
  static const String secondColumnTitle = 'titleSaved';
  static const String secondColumnLink = 'linkSaved';
  static const String secondColumnTimeStamp = 'timeStampSaved';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'info.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName(
            $columnNumber INTEGER,
            $columnTitle TEXT,
            $columnTimeStamp TEXT
          )
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $secondTableName(
            $secondColumnCode INTEGER,
            $secondColumnTitle TEXT,
            $secondColumnLink TEXT,
            $secondColumnTimeStamp TEXT
          )
          ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $secondTableName(
            $secondColumnCode INTEGER,
            $secondColumnTitle TEXT,
            $secondColumnLink TEXT,
            $secondColumnTimeStamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> resetTable() async {
    Database db = await database;

    await db.execute('DROP TABLE IF EXISTS $tableName');

    await db.execute('''
      CREATE TABLE $tableName(
        $columnNumber INTEGER,
        $columnTitle TEXT,
        $columnTimeStamp TEXT
      )
    ''');
  }

  Future<void> resetStoredTable() async {
    Database db = await database;

    await db.execute('DROP TABLE IF EXISTS $secondTableName');

    await db.execute('''
      CREATE TABLE $secondTableName(
        $secondColumnCode INTEGER,
        $secondColumnTitle TEXT,
        $secondColumnLink TEXT,
        $secondColumnTimeStamp TEXT
      )
    ''');
  }

  Future<int> insertInfo(Map<String, dynamic> info) async {
    Database db = await database;
    return await db.insert(tableName, info);
  }

  Future<int> saveNotification(Map<String, dynamic> info) async {
    info[secondColumnTimeStamp] = DateTime.now().toIso8601String();
    Database db = await database;
    return await db.insert(secondTableName, info);
  }

  Future<int> deleteNotification(int codeSaved) async {
    Database db = await database;
    return await db.delete(
      secondTableName,
      where: '$secondColumnCode = ?',
      whereArgs: [codeSaved],
    );
  }

  Future<List<Map<String, dynamic>>> getEveryDayData() async {
    Database db = await database;
    return db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> getPlanData() async {
    Database db = await database;
    return db.query(secondTableName);
  }
}
