import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final List<TransactionModel> filteredTransactions;
  final TransactionType? filterType;
  final String? filterCategory;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String searchQuery;
  final String? error;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.filterType,
    this.filterCategory,
    this.filterStartDate,
    this.filterEndDate,
    this.searchQuery = '',
    this.error,
  });

  bool get hasFilters =>
      filterType != null ||
      filterCategory != null ||
      filterStartDate != null ||
      filterEndDate != null ||
      searchQuery.isNotEmpty;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
    List<TransactionModel>? filteredTransactions,
    TransactionType? filterType,
    String? filterCategory,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? searchQuery,
    String? error,
    bool clearFilterType = false,
    bool clearFilterCategory = false,
    bool clearFilterStartDate = false,
    bool clearFilterEndDate = false,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      filterCategory: clearFilterCategory ? null : (filterCategory ?? this.filterCategory),
      filterStartDate: clearFilterStartDate ? null : (filterStartDate ?? this.filterStartDate),
      filterEndDate: clearFilterEndDate ? null : (filterEndDate ?? this.filterEndDate),
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactions,
        filteredTransactions,
        filterType,
        filterCategory,
        filterStartDate,
        filterEndDate,
        searchQuery,
        error,
      ];
}
