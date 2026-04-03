import 'package:finance_tracker/data/database/database_helper.dart';
import 'package:finance_tracker/data/database/database_constants.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper;

  TransactionRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  // ─── CRUD ──────────────────────────────────────────────────────────

  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    await db.insert(DatabaseConstants.transactionTable, transaction.toMap());
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseConstants.transactionTable,
      transaction.toMap(),
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseConstants.transactionTable,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.transactionTable,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return TransactionModel.fromMap(result.first);
  }

  // ─── Queries ───────────────────────────────────────────────────────

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.transactionTable,
      orderBy: '${DatabaseConstants.colDate} DESC',
    );
    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<List<TransactionModel>> getTransactionsByType(TransactionType type) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.transactionTable,
      where: '${DatabaseConstants.colType} = ?',
      whereArgs: [type.name],
      orderBy: '${DatabaseConstants.colDate} DESC',
    );
    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.transactionTable,
      where: '${DatabaseConstants.colDate} BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: '${DatabaseConstants.colDate} DESC',
    );
    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<List<TransactionModel>> searchTransactions(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.transactionTable,
      where: '${DatabaseConstants.colCategory} LIKE ? OR ${DatabaseConstants.colNote} LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: '${DatabaseConstants.colDate} DESC',
    );
    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<List<TransactionModel>> getFilteredTransactions({
    TransactionType? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    final db = await _dbHelper.database;
    final conditions = <String>[];
    final args = <dynamic>[];

    if (type != null) {
      conditions.add('${DatabaseConstants.colType} = ?');
      args.add(type.name);
    }
    if (category != null) {
      conditions.add('${DatabaseConstants.colCategory} = ?');
      args.add(category);
    }
    if (startDate != null) {
      conditions.add('${DatabaseConstants.colDate} >= ?');
      args.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      conditions.add('${DatabaseConstants.colDate} <= ?');
      args.add(endDate.toIso8601String());
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      conditions.add('(${DatabaseConstants.colCategory} LIKE ? OR ${DatabaseConstants.colNote} LIKE ?)');
      args.addAll(['%$searchQuery%', '%$searchQuery%']);
    }

    final result = await db.query(
      DatabaseConstants.transactionTable,
      where: conditions.isNotEmpty ? conditions.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      orderBy: '${DatabaseConstants.colDate} DESC',
    );
    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  // ─── Aggregations ─────────────────────────────────────────────────

  Future<double> getTotalIncome({DateTime? start, DateTime? end}) async {
    return _getTotal(TransactionType.income, start: start, end: end);
  }

  Future<double> getTotalExpense({DateTime? start, DateTime? end}) async {
    return _getTotal(TransactionType.expense, start: start, end: end);
  }

  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }

  Future<double> _getTotal(TransactionType type, {DateTime? start, DateTime? end}) async {
    final db = await _dbHelper.database;
    final conditions = ['${DatabaseConstants.colType} = ?'];
    final args = <dynamic>[type.name];

    if (start != null) {
      conditions.add('${DatabaseConstants.colDate} >= ?');
      args.add(start.toIso8601String());
    }
    if (end != null) {
      conditions.add('${DatabaseConstants.colDate} <= ?');
      args.add(end.toIso8601String());
    }

    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(${DatabaseConstants.colAmount}), 0) as total FROM ${DatabaseConstants.transactionTable} WHERE ${conditions.join(' AND ')}',
      args,
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<Map<String, double>> getCategoryTotals({
    TransactionType? type,
    DateTime? start,
    DateTime? end,
  }) async {
    final db = await _dbHelper.database;
    final conditions = <String>[];
    final args = <dynamic>[];

    if (type != null) {
      conditions.add('${DatabaseConstants.colType} = ?');
      args.add(type.name);
    }
    if (start != null) {
      conditions.add('${DatabaseConstants.colDate} >= ?');
      args.add(start.toIso8601String());
    }
    if (end != null) {
      conditions.add('${DatabaseConstants.colDate} <= ?');
      args.add(end.toIso8601String());
    }

    final whereClause = conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';

    final result = await db.rawQuery(
      'SELECT ${DatabaseConstants.colCategory}, SUM(${DatabaseConstants.colAmount}) as total FROM ${DatabaseConstants.transactionTable} $whereClause GROUP BY ${DatabaseConstants.colCategory} ORDER BY total DESC',
      args,
    );

    final map = <String, double>{};
    for (final row in result) {
      map[row['category'] as String] = (row['total'] as num).toDouble();
    }
    return map;
  }

  Future<Map<int, double>> getDailySpendingForWeek(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    final transactions = await getTransactionsByDateRange(weekStart, weekEnd);

    final dailyTotals = <int, double>{};
    for (int i = 0; i < 7; i++) {
      dailyTotals[i] = 0;
    }

    for (final t in transactions) {
      if (t.type == TransactionType.expense) {
        final dayIndex = t.date.difference(weekStart).inDays.clamp(0, 6);
        dailyTotals[dayIndex] = (dailyTotals[dayIndex] ?? 0) + t.amount;
      }
    }

    return dailyTotals;
  }

  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.transactionTable,
      orderBy: '${DatabaseConstants.colDate} DESC',
      limit: limit,
    );
    return result.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<Map<String, double>> getMonthlyTrend({int months = 6}) async {
    final now = DateTime.now();
    final map = <String, double>{};

    for (int i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthEnd = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59);
      final total = await _getTotal(TransactionType.expense, start: month, end: monthEnd);
      final key = '${month.month}/${month.year}';
      map[key] = total;
    }

    return map;
  }

  Future<int> getTransactionCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.transactionTable}',
    );
    return (result.first['count'] as int);
  }

  Future<String?> getMostFrequentCategory({TransactionType? type}) async {
    final db = await _dbHelper.database;
    final whereClause = type != null ? 'WHERE ${DatabaseConstants.colType} = ?' : '';
    final args = type != null ? [type.name] : <dynamic>[];

    final result = await db.rawQuery(
      'SELECT ${DatabaseConstants.colCategory}, COUNT(*) as cnt FROM ${DatabaseConstants.transactionTable} $whereClause GROUP BY ${DatabaseConstants.colCategory} ORDER BY cnt DESC LIMIT 1',
      args,
    );
    if (result.isEmpty) return null;
    return result.first['category'] as String;
  }

  Future<List<Map<String, dynamic>>> getDailySpendingForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    final transactions = await getTransactionsByDateRange(start, end);

    final dailyMap = <String, double>{};
    for (final t in transactions) {
      if (t.type == TransactionType.expense) {
        final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}';
        dailyMap[key] = (dailyMap[key] ?? 0) + t.amount;
      }
    }

    return dailyMap.entries
        .map((e) => {'date': e.key, 'amount': e.value})
        .toList();
  }
}
