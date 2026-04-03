import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/features/insights/bloc/insights_bloc.dart';
import 'package:finance_tracker/features/insights/bloc/insights_event.dart';
import 'package:finance_tracker/features/insights/bloc/insights_state.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';
import 'package:finance_tracker/features/insights/widgets/period_selector.dart';
import 'package:finance_tracker/features/insights/widgets/insights_content.dart';
import 'package:finance_tracker/shared/widgets/shimmer_loading.dart';
import 'package:finance_tracker/shared/widgets/error_widget.dart';
import 'package:finance_tracker/shared/widgets/empty_state_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InsightsBloc>().add(LoadInsights());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<InsightsBloc, InsightsState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Insights',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                PeriodSelector(
                  periods: const ['This Week', 'This Month', 'All Time'],
                  selectedIndex: state.periodIndex,
                  onChanged: (i) => context.read<InsightsBloc>().add(ChangeInsightsPeriod(i)),
                ),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, InsightsState state) {
    if (state.status == InsightsStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          ShimmerCard(height: 80),
          SizedBox(height: 16),
          ShimmerCard(height: 120),
          SizedBox(height: 16),
          ShimmerCard(height: 280),
        ]),
      );
    }
    if (state.status == InsightsStatus.error) {
      return AppErrorWidget(
        message: state.error ?? 'Failed to load insights',
        onRetry: () => context.read<InsightsBloc>().add(LoadInsights()),
      );
    }
    if (state.totalTransactions == 0 && state.categoryBreakdown.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.insights_rounded,
        title: 'No Insights Yet',
        subtitle: 'Start adding transactions to see your spending patterns.',
      );
    }
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return InsightsContent(state: state, currencySymbol: settingsState.currencySymbol);
      },
    );
  }
}
