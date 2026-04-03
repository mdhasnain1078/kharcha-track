import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleTheme extends SettingsEvent {
  final ThemeMode themeMode;

  const ToggleTheme(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ChangeCurrency extends SettingsEvent {
  final String symbol;

  const ChangeCurrency(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

class ClearAllData extends SettingsEvent {}

class ExportData extends SettingsEvent {}

class ToggleBiometrics extends SettingsEvent {
  final bool enabled;

  const ToggleBiometrics(this.enabled);

  @override
  List<Object?> get props => [enabled];
}
