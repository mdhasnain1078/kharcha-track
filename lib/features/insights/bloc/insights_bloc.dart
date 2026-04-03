import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/core/utils/date_utils.dart';
import 'insights_event.dart';
import 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final TransactionRepository _repo;

  InsightsBloc({required TransactionRepository transactionRepository})
      : _repo = transactionRepository,
        super(const InsightsState()) {
    on<LoadInsights>(_onLoadInsights);
    on<ChangeInsightsPeriod>(_onChangePeriod);
  }

  Future<void> _onLoadInsights(LoadInsights event, Emitter<InsightsState> emit) async {
    emit(state.copyWith(status: InsightsStatus.loading));
    await _loadData(emit, state.periodIndex);
  }

  Future<void> _onChangePeriod(ChangeInsightsPeriod event, Emitter<InsightsState> emit) async {
    emit(state.copyWith(periodIndex: event.periodIndex, status: InsightsStatus.loading));
    await _loadData(emit, event.periodIndex);
  }

  Future<void> _loadData(Emitter<InsightsState> emit, int periodIndex) async {
    try {
      DateTime? start;
      DateTime? end;

      switch (periodIndex) {
        case 0: // This week
          start = AppDateUtils.startOfWeek;
          end = AppDateUtils.endOfWeek;
          break;
        case 1: // This month
          start = AppDateUtils.startOfMonth;
          end = AppDateUtils.endOfMonth;
          break;
        case 2: // All time
          break;
      }

      // Category breakdown
      final categoryBreakdown = await _repo.getCategoryTotals(
        type: TransactionType.expense,
        start: start,
        end: end,
      );

      // Top category
      String? topCategory;
      double topCategoryAmount = 0;
      if (categoryBreakdown.isNotEmpty) {
        topCategory = categoryBreakdown.entries.first.key;
        topCategoryAmount = categoryBreakdown.entries.first.value;
      }

      // Weekly comparison
      final thisWeekTotal = await _repo.getTotalExpense(
        start: AppDateUtils.startOfWeek,
        end: AppDateUtils.endOfWeek,
      );
      final lastWeekTotal = await _repo.getTotalExpense(
        start: AppDateUtils.startOfLastWeek,
        end: AppDateUtils.endOfLastWeek,
      );

      // Monthly trend
      final monthlyTrend = await _repo.getMonthlyTrend(months: 6);

      // Transaction stats and Frequent type
      final allTransactions = await _repo.getFilteredTransactions(
        type: TransactionType.expense,
        startDate: start,
        endDate: end,
      );
      final totalCount = allTransactions.length;
      final totalAmount = allTransactions.fold<double>(0, (s, t) => s + t.amount);
      final average = totalCount > 0 ? totalAmount / totalCount : 0.0;

      String? frequentCategory;
      if (allTransactions.isNotEmpty) {
        final freq = <String, int>{};
        for (final t in allTransactions) {
          if (t.type == TransactionType.expense) {
            freq[t.category] = (freq[t.category] ?? 0) + 1;
          }
        }
        if (freq.isNotEmpty) {
          frequentCategory = freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        }
      }

      // Daily spending for heatmap
      final dailySpending = await _repo.getDailySpendingForMonth(DateTime.now());

      emit(state.copyWith(
        status: InsightsStatus.loaded,
        topCategory: topCategory,
        topCategoryAmount: topCategoryAmount,
        categoryBreakdown: categoryBreakdown,
        thisWeekTotal: thisWeekTotal,
        lastWeekTotal: lastWeekTotal,
        monthlyTrend: monthlyTrend,
        frequentType: frequentCategory,
        totalTransactions: totalCount,
        averageTransaction: average,
        dailySpending: dailySpending,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InsightsStatus.error,
        error: 'Failed to load insights',
      ));
    }
  }
}
