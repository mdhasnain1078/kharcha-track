import 'package:equatable/equatable.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final TransactionModel transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final String id;

  const DeleteTransaction(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterTransactions extends TransactionEvent {
  final TransactionType? type;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterTransactions({this.type, this.category, this.startDate, this.endDate});

  @override
  List<Object?> get props => [type, category, startDate, endDate];
}

class SearchTransactions extends TransactionEvent {
  final String query;

  const SearchTransactions(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearFilters extends TransactionEvent {}
