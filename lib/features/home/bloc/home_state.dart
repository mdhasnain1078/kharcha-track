import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final double balance;
  final double totalIncome;
  final double totalExpense;
  final double savingsProgress;
  final double totalSaved;
  final double totalTarget;
  final int activeGoalCount;
  final Map<int, double> weeklySpending;
  final Map<String, double> categoryBreakdown;
  final List<TransactionModel> recentTransactions;
  final String? error;

  const HomeState({
    this.status = HomeStatus.initial,
    this.balance = 0,
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.savingsProgress = 0,
    this.totalSaved = 0,
    this.totalTarget = 0,
    this.activeGoalCount = 0,
    this.weeklySpending = const {},
    this.categoryBreakdown = const {},
    this.recentTransactions = const [],
    this.error,
  });

  HomeState copyWith({
    HomeStatus? status,
    double? balance,
    double? totalIncome,
    double? totalExpense,
    double? savingsProgress,
    double? totalSaved,
    double? totalTarget,
    int? activeGoalCount,
    Map<int, double>? weeklySpending,
    Map<String, double>? categoryBreakdown,
    List<TransactionModel>? recentTransactions,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      savingsProgress: savingsProgress ?? this.savingsProgress,
      totalSaved: totalSaved ?? this.totalSaved,
      totalTarget: totalTarget ?? this.totalTarget,
      activeGoalCount: activeGoalCount ?? this.activeGoalCount,
      weeklySpending: weeklySpending ?? this.weeklySpending,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        balance,
        totalIncome,
        totalExpense,
        savingsProgress,
        totalSaved,
        totalTarget,
        activeGoalCount,
        weeklySpending,
        categoryBreakdown,
        recentTransactions,
        error,
      ];
}
