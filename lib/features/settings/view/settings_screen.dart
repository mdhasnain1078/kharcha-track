import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/shared/widgets/section_header.dart';
import 'package:finance_tracker/shared/widgets/confirm_dialog.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_event.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';
import 'package:finance_tracker/features/settings/widgets/settings_card.dart';
import 'package:finance_tracker/features/settings/widgets/settings_tile.dart';
import 'package:finance_tracker/features/settings/widgets/currency_picker_sheet.dart';
import 'package:finance_tracker/features/home/bloc/home_bloc.dart';
import 'package:finance_tracker/features/home/bloc/home_event.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_event.dart';
import 'package:finance_tracker/features/goals/bloc/goal_bloc.dart';
import 'package:finance_tracker/features/goals/bloc/goal_event.dart';
import 'package:finance_tracker/features/insights/bloc/insights_bloc.dart';
import 'package:finance_tracker/features/insights/bloc/insights_event.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.message != null) {
            context.showSnackBar(state.message!);
            if (state.message == 'All data cleared successfully') {
              context.read<HomeBloc>().add(LoadDashboard());
              context.read<TransactionBloc>().add(LoadTransactions());
              context.read<GoalBloc>().add(LoadGoals());
              context.read<InsightsBloc>().add(LoadInsights());
            }
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SectionHeader(title: 'Appearance'),
              const SizedBox(height: 12),
              SettingsCard(children: [
                SettingsTile(
                  icon: Icons.dark_mode_rounded,
                  iconColor: AppColors.primary,
                  title: 'Dark Mode',
                  trailing: Switch.adaptive(
                    value: context.isDark,
                    activeColor: AppColors.primary,
                    onChanged: (v) => context.read<SettingsBloc>().add(
                          ToggleTheme(v ? ThemeMode.dark : ThemeMode.light),
                        ),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Security'),
              const SizedBox(height: 12),
              SettingsCard(children: [
                SettingsTile(
                  icon: Icons.fingerprint_rounded,
                  iconColor: AppColors.income,
                  title: 'App Lock',
                  subtitle: 'Require biometric authentication to open',
                  trailing: Switch.adaptive(
                    value: state.useBiometrics,
                    activeColor: AppColors.primary,
                    onChanged: (v) => context.read<SettingsBloc>().add(ToggleBiometrics(v)),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Currency'),
              const SizedBox(height: 12),
              SettingsCard(children: [
                SettingsTile(
                  icon: Icons.currency_rupee_rounded,
                  iconColor: AppColors.accent,
                  title: 'Currency Symbol',
                  subtitle: state.currencySymbol,
                  onTap: () => CurrencyPickerSheet.show(context, state.currencySymbol),
                ),
              ]),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Data'),
              const SizedBox(height: 12),
              SettingsCard(children: [
                SettingsTile(
                  icon: Icons.file_download_rounded,
                  iconColor: AppColors.categoryTransport,
                  title: 'Export Transactions',
                  subtitle: 'Export as CSV file',
                  onTap: () => context.read<SettingsBloc>().add(ExportData()),
                ),
                Divider(
                  color: context.isDark ? AppColors.darkBorder : AppColors.divider,
                  height: 1,
                ),
                SettingsTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: AppColors.expense,
                  title: 'Clear All Data',
                  subtitle: 'Delete all transactions and goals',
                  onTap: () => _confirmClearData(context),
                ),
              ]),
              const SizedBox(height: 24),
              const SectionHeader(title: 'About'),
              const SizedBox(height: 12),
              SettingsCard(children: [
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.categoryEntertainment,
                  title: 'Kharch Tracker',
                  subtitle: 'Version 1.0.0',
                ),
              ]),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  void _confirmClearData(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Clear All Data?',
      message: 'This will permanently delete all your transactions, goals, and streak data. This action cannot be undone.',
      confirmLabel: 'Delete Everything',
    );
    if (confirmed && context.mounted) {
      context.read<SettingsBloc>().add(ClearAllData());
    }
  }
}
