import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_constants.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseConstants.createTransactionTable);
    await db.execute(DatabaseConstants.createGoalTable);
    await db.execute(DatabaseConstants.createStreakTable);

    // Create indexes for performance
    await db.execute(
      'CREATE INDEX idx_transaction_date ON ${DatabaseConstants.transactionTable} (${DatabaseConstants.colDate})',
    );
    await db.execute(
      'CREATE INDEX idx_transaction_type ON ${DatabaseConstants.transactionTable} (${DatabaseConstants.colType})',
    );
    await db.execute(
      'CREATE INDEX idx_transaction_category ON ${DatabaseConstants.transactionTable} (${DatabaseConstants.colCategory})',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations here
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(DatabaseConstants.transactionTable);
    await db.delete(DatabaseConstants.goalTable);
    await db.delete(DatabaseConstants.streakTable);
  }
}
