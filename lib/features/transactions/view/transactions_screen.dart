import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_event.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_state.dart';
import 'package:finance_tracker/features/transactions/widgets/transaction_header.dart';
import 'package:finance_tracker/features/transactions/widgets/transaction_search_bar.dart';
import 'package:finance_tracker/features/transactions/widgets/transaction_type_tabs.dart';
import 'package:finance_tracker/features/transactions/widgets/transaction_grouped_list.dart';
import 'package:finance_tracker/features/transactions/widgets/transaction_filter_sheet.dart';
import 'package:finance_tracker/features/transactions/widgets/empty_transactions.dart';
import 'package:finance_tracker/shared/widgets/shimmer_loading.dart';
import 'package:finance_tracker/shared/widgets/error_widget.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  TransactionType? _selectedType;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TransactionHeader(filterButton: _buildFilterButton()),
            TransactionSearchBar(controller: _searchController),
            TransactionTypeTabs(
              selectedType: _selectedType,
              onChanged: (type) {
                setState(() => _selectedType = type);
                context.read<TransactionBloc>().add(FilterTransactions(type: type));
              },
            ),
            Expanded(child: _buildList(isDark)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildFilterButton() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final isDark = context.isDark;
        return GestureDetector(
          onTap: () => _showFilterSheet(context, state),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: state.hasFilters
                  ? AppColors.primary.withOpacity(0.1)
                  : (isDark ? AppColors.darkCard : AppColors.surface),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: state.hasFilters ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border),
              ),
            ),
            child: Icon(Icons.tune_rounded, size: 22,
              color: state.hasFilters ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
          ),
        );
      },
    );
  }

  Widget _buildList(bool isDark) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state.status == TransactionStatus.loading) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: List.generate(5, (_) => const Padding(padding: EdgeInsets.only(bottom: 8), child: ShimmerListTile()))),
          );
        }
        if (state.status == TransactionStatus.error) {
          return AppErrorWidget(message: state.error ?? 'Failed to load', onRetry: () => context.read<TransactionBloc>().add(LoadTransactions()));
        }
        if (state.filteredTransactions.isEmpty) {
          if (state.hasFilters) {
            return _buildEmptyFiltered(isDark);
          }
          return EmptyTransactions(onAdd: () => context.push('/transactions/add'));
        }
        return TransactionGroupedList(transactions: state.filteredTransactions);
      },
    );
  }

  Widget _buildEmptyFiltered(bool isDark) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_off_rounded, size: 48, color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
        const SizedBox(height: 16),
        Text('No matching transactions', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () { setState(() => _selectedType = null); _searchController.clear(); context.read<TransactionBloc>().add(ClearFilters()); },
          child: const Text('Clear Filters'),
        ),
      ]),
    );
  }

  void _showFilterSheet(BuildContext context, TransactionState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TransactionFilterSheet(
        currentType: state.filterType,
        currentCategory: state.filterCategory,
        currentStartDate: state.filterStartDate,
        currentEndDate: state.filterEndDate,
        onApply: (type, category, start, end) {
          setState(() => _selectedType = type);
          context.read<TransactionBloc>().add(FilterTransactions(type: type, category: category, startDate: start, endDate: end));
        },
        onClear: () { setState(() => _selectedType = null); _searchController.clear(); context.read<TransactionBloc>().add(ClearFilters()); },
      ),
    );
  }
}
