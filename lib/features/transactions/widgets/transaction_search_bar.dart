import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_event.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const TransactionSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          context.read<TransactionBloc>().add(SearchTransactions(value));
        },
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          prefixIcon: const Icon(Icons.search_rounded, size: 22),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    controller.clear();
                    context.read<TransactionBloc>().add(const SearchTransactions(''));
                  },
                )
              : null,
        ),
      ),
    );
  }
}
