import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repo;

  TransactionBloc({required TransactionRepository transactionRepository})
      : _repo = transactionRepository,
        super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<FilterTransactions>(_onFilterTransactions);
    on<SearchTransactions>(_onSearchTransactions);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final transactions = await _repo.getAllTransactions();
      emit(state.copyWith(
        status: TransactionStatus.loaded,
        transactions: transactions,
        filteredTransactions: transactions,
      ));
    } catch (e) {
      emit(state.copyWith(status: TransactionStatus.error, error: 'Failed to load transactions'));
    }
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _repo.insertTransaction(event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add transaction'));
    }
  }

  Future<void> _onUpdateTransaction(UpdateTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _repo.updateTransaction(event.transaction);
      add(LoadTransactions());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update transaction'));
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _repo.deleteTransaction(event.id);
      add(LoadTransactions());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete transaction'));
    }
  }

  Future<void> _onFilterTransactions(FilterTransactions event, Emitter<TransactionState> emit) async {
    try {
      final filtered = await _repo.getFilteredTransactions(
        type: event.type,
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(state.copyWith(
        filteredTransactions: filtered,
        filterType: event.type,
        filterCategory: event.category,
        filterStartDate: event.startDate,
        filterEndDate: event.endDate,
        clearFilterType: event.type == null,
        clearFilterCategory: event.category == null,
        clearFilterStartDate: event.startDate == null,
        clearFilterEndDate: event.endDate == null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to filter transactions'));
    }
  }

  Future<void> _onSearchTransactions(SearchTransactions event, Emitter<TransactionState> emit) async {
    try {
      if (event.query.isEmpty) {
        emit(state.copyWith(
          filteredTransactions: state.transactions,
          searchQuery: '',
        ));
        return;
      }
      final results = await _repo.searchTransactions(event.query);
      emit(state.copyWith(
        filteredTransactions: results,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to search transactions'));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<TransactionState> emit) {
    emit(state.copyWith(
      filteredTransactions: state.transactions,
      searchQuery: '',
      clearFilterType: true,
      clearFilterCategory: true,
      clearFilterStartDate: true,
      clearFilterEndDate: true,
    ));
  }
}
