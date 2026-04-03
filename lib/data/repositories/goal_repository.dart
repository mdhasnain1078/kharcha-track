import 'package:finance_tracker/data/database/database_helper.dart';
import 'package:finance_tracker/data/database/database_constants.dart';
import 'package:finance_tracker/data/models/goal_model.dart';
import 'package:sqflite/sqflite.dart';

class GoalRepository {
  final DatabaseHelper _dbHelper;

  GoalRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  // ─── CRUD ──────────────────────────────────────────────────────────

  Future<void> insertGoal(GoalModel goal) async {
    final db = await _dbHelper.database;
    await db.insert(DatabaseConstants.goalTable, goal.toMap());
  }

  Future<void> updateGoal(GoalModel goal) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.goalTable,
      goal.toMap(),
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [goal.id],
    );
  }

  Future<void> deleteGoal(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseConstants.goalTable,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<GoalModel?> getGoalById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.goalTable,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return GoalModel.fromMap(result.first);
  }

  // ─── Queries ───────────────────────────────────────────────────────

  Future<List<GoalModel>> getAllGoals() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.goalTable,
      orderBy: '${DatabaseConstants.colCreatedAt} DESC',
    );
    return result.map((m) => GoalModel.fromMap(m)).toList();
  }

  Future<List<GoalModel>> getActiveGoals() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.goalTable,
      where: '${DatabaseConstants.colIsCompleted} = ?',
      whereArgs: [0],
      orderBy: '${DatabaseConstants.colDeadline} ASC',
    );
    return result.map((m) => GoalModel.fromMap(m)).toList();
  }

  Future<List<GoalModel>> getCompletedGoals() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.goalTable,
      where: '${DatabaseConstants.colIsCompleted} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseConstants.colCreatedAt} DESC',
    );
    return result.map((m) => GoalModel.fromMap(m)).toList();
  }

  Future<void> contributeToGoal(String id, double amount) async {
    final goal = await getGoalById(id);
    if (goal == null) return;

    final newSaved = goal.savedAmount + amount;
    final isCompleted = newSaved >= goal.targetAmount;

    await updateGoal(goal.copyWith(
      savedAmount: newSaved,
      isCompleted: isCompleted,
    ));
  }

  // ─── Aggregations ─────────────────────────────────────────────────

  Future<double> getTotalSaved() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(${DatabaseConstants.colSavedAmount}), 0) as total FROM ${DatabaseConstants.goalTable} WHERE ${DatabaseConstants.colIsCompleted} = 0',
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<double> getTotalTarget() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(${DatabaseConstants.colTargetAmount}), 0) as total FROM ${DatabaseConstants.goalTable} WHERE ${DatabaseConstants.colIsCompleted} = 0',
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<int> getActiveGoalCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.goalTable} WHERE ${DatabaseConstants.colIsCompleted} = 0',
    );
    return (result.first['count'] as int);
  }

  Future<int> getCompletedGoalCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.goalTable} WHERE ${DatabaseConstants.colIsCompleted} = 1',
    );
    return (result.first['count'] as int);
  }

  // ─── Streak ────────────────────────────────────────────────────────

  Future<void> markDayAsSaved(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    await db.insert(
      DatabaseConstants.streakTable,
      {DatabaseConstants.colStreakDate: dateStr, DatabaseConstants.colDidSave: 1},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getCurrentStreak() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.streakTable,
      where: '${DatabaseConstants.colDidSave} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseConstants.colStreakDate} DESC',
    );

    if (result.isEmpty) return 0;

    int streak = 0;
    DateTime expectedDate = DateTime.now();
    // Allow today to be unmarked — start from yesterday
    final todayStr = '${expectedDate.year}-${expectedDate.month.toString().padLeft(2, '0')}-${expectedDate.day.toString().padLeft(2, '0')}';

    bool startedCounting = false;

    for (final row in result) {
      final dateStr = row[DatabaseConstants.colStreakDate] as String;

      if (!startedCounting) {
        // Check if latest entry is today or yesterday
        if (dateStr == todayStr) {
          streak = 1;
          expectedDate = expectedDate.subtract(const Duration(days: 1));
          startedCounting = true;
          continue;
        }
        final yesterday = expectedDate.subtract(const Duration(days: 1));
        final yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
        if (dateStr == yesterdayStr) {
          streak = 1;
          expectedDate = yesterday.subtract(const Duration(days: 1));
          startedCounting = true;
          continue;
        }
        return 0;
      }

      final expectedStr = '${expectedDate.year}-${expectedDate.month.toString().padLeft(2, '0')}-${expectedDate.day.toString().padLeft(2, '0')}';
      if (dateStr == expectedStr) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<List<String>> getSavingDatesForMonth(DateTime month) async {
    final db = await _dbHelper.database;
    final monthStr = '${month.year}-${month.month.toString().padLeft(2, '0')}';
    final result = await db.query(
      DatabaseConstants.streakTable,
      where: '${DatabaseConstants.colStreakDate} LIKE ? AND ${DatabaseConstants.colDidSave} = ?',
      whereArgs: ['$monthStr%', 1],
    );
    return result.map((r) => r[DatabaseConstants.colStreakDate] as String).toList();
  }
}
