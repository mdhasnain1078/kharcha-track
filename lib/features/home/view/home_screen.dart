import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/features/home/bloc/home_bloc.dart';
import 'package:finance_tracker/features/home/bloc/home_event.dart';
import 'package:finance_tracker/features/home/bloc/home_state.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';
import 'package:finance_tracker/features/home/widgets/home_header.dart';
import 'package:finance_tracker/features/home/widgets/home_content.dart';
import 'package:finance_tracker/shared/widgets/shimmer_loading.dart';
import 'package:finance_tracker/shared/widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.error) {
              return AppErrorWidget(
                message: state.error ?? 'Something went wrong',
                onRetry: () => context.read<HomeBloc>().add(LoadDashboard()),
              );
            }
            return Column(
              children: [
                const HomeHeader(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(RefreshDashboard());
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    color: AppColors.primary,
                    child: _buildContent(state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(HomeState state) {
    if (state.status == HomeStatus.loading) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ShimmerCard(height: 170), SizedBox(height: 16),
          Row(children: [Expanded(child: ShimmerCard(height: 120)), SizedBox(width: 16), Expanded(child: ShimmerCard(height: 120))]),
          SizedBox(height: 16), ShimmerCard(height: 240),
        ],
      );
    }
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return HomeContent(state: state, currencySymbol: settingsState.currencySymbol);
      },
    );
  }
}
