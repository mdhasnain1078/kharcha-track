class DatabaseConstants {
  DatabaseConstants._();

  static const String databaseName = 'finance_tracker.db';
  static const int databaseVersion = 1;

  // ─── Transaction Table ─────────────────────────────────────────────
  static const String transactionTable = 'transactions';
  static const String colId = 'id';
  static const String colAmount = 'amount';
  static const String colType = 'type';
  static const String colCategory = 'category';
  static const String colDate = 'date';
  static const String colNote = 'note';
  static const String colCreatedAt = 'created_at';

  // ─── Goal Table ────────────────────────────────────────────────────
  static const String goalTable = 'goals';
  static const String colTitle = 'title';
  static const String colTargetAmount = 'target_amount';
  static const String colSavedAmount = 'saved_amount';
  static const String colDeadline = 'deadline';
  static const String colIconCodePoint = 'icon_code_point';
  static const String colColor = 'color';
  static const String colIsCompleted = 'is_completed';

  // ─── Streak Table ──────────────────────────────────────────────────
  static const String streakTable = 'savings_streak';
  static const String colStreakDate = 'streak_date';
  static const String colDidSave = 'did_save';

  // ─── Create Statements ─────────────────────────────────────────────
  static const String createTransactionTable = '''
    CREATE TABLE $transactionTable (
      $colId TEXT PRIMARY KEY,
      $colAmount REAL NOT NULL,
      $colType TEXT NOT NULL,
      $colCategory TEXT NOT NULL,
      $colDate TEXT NOT NULL,
      $colNote TEXT,
      $colCreatedAt TEXT NOT NULL
    )
  ''';

  static const String createGoalTable = '''
    CREATE TABLE $goalTable (
      $colId TEXT PRIMARY KEY,
      $colTitle TEXT NOT NULL,
      $colTargetAmount REAL NOT NULL,
      $colSavedAmount REAL NOT NULL DEFAULT 0,
      $colDeadline TEXT NOT NULL,
      $colIconCodePoint INTEGER NOT NULL,
      $colColor INTEGER NOT NULL,
      $colIsCompleted INTEGER NOT NULL DEFAULT 0,
      $colCreatedAt TEXT NOT NULL
    )
  ''';

  static const String createStreakTable = '''
    CREATE TABLE $streakTable (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colStreakDate TEXT NOT NULL UNIQUE,
      $colDidSave INTEGER NOT NULL DEFAULT 0
    )
  ''';
}
