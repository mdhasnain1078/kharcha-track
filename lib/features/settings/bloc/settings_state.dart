import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final String currencySymbol;
  final bool useBiometrics;
  final bool isLoading;
  final String? message;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.currencySymbol = '₹',
    this.useBiometrics = false,
    this.isLoading = false,
    this.message,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? currencySymbol,
    bool? useBiometrics,
    bool? isLoading,
    String? message,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      isLoading: isLoading ?? this.isLoading,
      message: message,
    );
  }

  @override
  List<Object?> get props => [themeMode, currencySymbol, useBiometrics, isLoading, message];
}
