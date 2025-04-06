import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/form_submission.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'form_data.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE form_submissions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      form INTEGER NOT NULL,
      data TEXT NOT NULL,
      submitted_at TEXT NOT NULL,
      is_synced INTEGER DEFAULT 0
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE form_submissions ADD COLUMN form_name TEXT DEFAULT ""');
    }
  }

  Future<int> insertFormSubmission(FormSubmission submission) async {
    final db = await database;
    return await db.insert('form_submissions', submission.toMap());
  }

  Future<List<FormSubmission>> getFormSubmissions(int formId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'form_submissions',
      where: 'form = ?',
      whereArgs: [formId],
    );

    return List.generate(maps.length, (i) {
      return FormSubmission.fromMap(maps[i]);
    });
  }

  Future<List<FormSubmission>> getUnSyncedSubmissions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'form_submissions',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (i) {
      return FormSubmission.fromMap(maps[i]);
    });
  }

  Future<int> markSubmissionSynced(int id) async {
    final db = await database;
    return await db.update(
      'form_submissions',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnsyncedSubmissionsCount() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM form_submissions WHERE is_synced = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
