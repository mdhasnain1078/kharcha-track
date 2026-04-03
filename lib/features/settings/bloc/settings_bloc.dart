import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:finance_tracker/data/repositories/settings_repository.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/data/database/database_helper.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepo;
  final TransactionRepository _transactionRepo;

  SettingsBloc({
    required SettingsRepository settingsRepository,
    required TransactionRepository transactionRepository,
  })  : _settingsRepo = settingsRepository,
        _transactionRepo = transactionRepository,
        super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleTheme>(_onToggleTheme);
    on<ChangeCurrency>(_onChangeCurrency);
    on<ToggleBiometrics>(_onToggleBiometrics);
    on<ClearAllData>(_onClearAllData);
    on<ExportData>(_onExportData);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      themeMode: _settingsRepo.getThemeMode(),
      currencySymbol: _settingsRepo.getCurrencySymbol(),
      useBiometrics: _settingsRepo.getBiometricsEnabled(),
    ));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<SettingsState> emit) async {
    await _settingsRepo.setThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onChangeCurrency(ChangeCurrency event, Emitter<SettingsState> emit) async {
    await _settingsRepo.setCurrencySymbol(event.symbol);
    emit(state.copyWith(currencySymbol: event.symbol));
  }

  Future<void> _onToggleBiometrics(ToggleBiometrics event, Emitter<SettingsState> emit) async {
    await _settingsRepo.setBiometricsEnabled(event.enabled);
    emit(state.copyWith(useBiometrics: event.enabled));
  }

  Future<void> _onClearAllData(ClearAllData event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await DatabaseHelper().clearAllData();
      emit(state.copyWith(isLoading: false, message: 'All data cleared successfully'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'Failed to clear data'));
    }
  }

  Future<void> _onExportData(ExportData event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final transactions = await _transactionRepo.getAllTransactions();

      final rows = <List<dynamic>>[
        ['Date', 'Type', 'Category', 'Amount', 'Note'],
        ...transactions.map((t) => [
              t.date.toIso8601String(),
              t.type.name,
              t.category,
              t.amount,
              t.note ?? '',
            ]),
      ];

      final csv = const ListToCsvConverter().convert(rows);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/kharch_tracker_transactions.csv');
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(file.path)], text: 'Kharch Tracker Transactions Export');

      emit(state.copyWith(isLoading: false, message: 'Data exported successfully'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'Failed to export data'));
    }
  }
}
