import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/core/theme/app_theme.dart';
import 'package:finance_tracker/navigation/app_router.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/data/repositories/goal_repository.dart';
import 'package:finance_tracker/data/repositories/settings_repository.dart';
import 'package:finance_tracker/features/home/bloc/home_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/goals/bloc/goal_bloc.dart';
import 'package:finance_tracker/features/insights/bloc/insights_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_event.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';
import 'package:finance_tracker/shared/widgets/biometric_guard.dart';

class App extends StatelessWidget {
  final SettingsRepository settingsRepository;

  const App({super.key, required this.settingsRepository});

  @override
  Widget build(BuildContext context) {
    final transactionRepo = TransactionRepository();
    final goalRepo = GoalRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: transactionRepo),
        RepositoryProvider.value(value: goalRepo),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SettingsBloc(
              settingsRepository: settingsRepository,
              transactionRepository: transactionRepo,
            )..add(LoadSettings()),
          ),
          BlocProvider(
            create: (_) => HomeBloc(
              transactionRepository: transactionRepo,
              goalRepository: goalRepo,
            ),
          ),
          BlocProvider(
            create: (_) => TransactionBloc(
              transactionRepository: transactionRepo,
            ),
          ),
          BlocProvider(
            create: (_) => GoalBloc(
              goalRepository: goalRepo,
            ),
          ),
          BlocProvider(
            create: (_) => InsightsBloc(
              transactionRepository: transactionRepo,
            ),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return BiometricGuard(
              child: MaterialApp.router(
                title: 'Kharch Tracker',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                routerConfig: AppRouter.router,
              ),
            );
          },
        ),
      ),
    );
  }
}
