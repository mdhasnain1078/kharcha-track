import 'package:equatable/equatable.dart';

enum InsightsStatus { initial, loading, loaded, error }

class InsightsState extends Equatable {
  final InsightsStatus status;
  final int periodIndex;
  final String? topCategory;
  final double topCategoryAmount;
  final Map<String, double> categoryBreakdown;
  final double thisWeekTotal;
  final double lastWeekTotal;
  final Map<String, double> monthlyTrend;
  final String? frequentType;
  final int totalTransactions;
  final double averageTransaction;
  final List<Map<String, dynamic>> dailySpending;
  final String? error;

  const InsightsState({
    this.status = InsightsStatus.initial,
    this.periodIndex = 1,
    this.topCategory,
    this.topCategoryAmount = 0,
    this.categoryBreakdown = const {},
    this.thisWeekTotal = 0,
    this.lastWeekTotal = 0,
    this.monthlyTrend = const {},
    this.frequentType,
    this.totalTransactions = 0,
    this.averageTransaction = 0,
    this.dailySpending = const [],
    this.error,
  });

  double get weeklyChange {
    if (lastWeekTotal == 0) return 0;
    return ((thisWeekTotal - lastWeekTotal) / lastWeekTotal * 100);
  }

  InsightsState copyWith({
    InsightsStatus? status,
    int? periodIndex,
    String? topCategory,
    double? topCategoryAmount,
    Map<String, double>? categoryBreakdown,
    double? thisWeekTotal,
    double? lastWeekTotal,
    Map<String, double>? monthlyTrend,
    String? frequentType,
    int? totalTransactions,
    double? averageTransaction,
    List<Map<String, dynamic>>? dailySpending,
    String? error,
  }) {
    return InsightsState(
      status: status ?? this.status,
      periodIndex: periodIndex ?? this.periodIndex,
      topCategory: topCategory ?? this.topCategory,
      topCategoryAmount: topCategoryAmount ?? this.topCategoryAmount,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      thisWeekTotal: thisWeekTotal ?? this.thisWeekTotal,
      lastWeekTotal: lastWeekTotal ?? this.lastWeekTotal,
      monthlyTrend: monthlyTrend ?? this.monthlyTrend,
      frequentType: frequentType ?? this.frequentType,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      averageTransaction: averageTransaction ?? this.averageTransaction,
      dailySpending: dailySpending ?? this.dailySpending,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status, periodIndex, topCategory, topCategoryAmount,
        categoryBreakdown, thisWeekTotal, lastWeekTotal,
        monthlyTrend, frequentType, totalTransactions,
        averageTransaction, dailySpending, error,
      ];
}
