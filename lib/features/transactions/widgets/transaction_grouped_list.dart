import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/core/utils/date_utils.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_event.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';
import 'package:finance_tracker/features/transactions/widgets/transaction_list_item.dart';

class TransactionGroupedList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionGroupedList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grouped = _groupByDate(transactions);

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            final entry = grouped.entries.elementAt(index);
            return Padding(
              padding: EdgeInsets.only(bottom: index == grouped.length - 1 ? 80 : 16),
              child: StickyHeader(
                header: Container(
                  width: double.infinity,
                  color: isDark ? AppColors.darkBackground : AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                ),
                content: Card(
                    child: Column(
                      children: entry.value.asMap().entries.map((e) {
                        return Column(
                          children: [
                            TransactionListItem(
                              transaction: e.value,
                              currencySymbol: settingsState.currencySymbol,
                              onTap: () => context.push('/transactions/edit/${e.value.id}'),
                              onDelete: () {
                                context.read<TransactionBloc>().add(DeleteTransaction(e.value.id));
                                context.showSuccessSnackBar('Transaction deleted');
                              },
                            ),
                            if (e.key < entry.value.length - 1)
                              Divider(
                                height: 1,
                                indent: 78,
                                color: isDark ? AppColors.darkBorder : AppColors.divider,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              ),
            );
          },
        );
      },
    );
  }

  Map<String, List<TransactionModel>> _groupByDate(List<TransactionModel> txns) {
    final map = <String, List<TransactionModel>>{};
    for (final t in txns) {
      final key = AppDateUtils.getRelativeDate(t.date);
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }
}
