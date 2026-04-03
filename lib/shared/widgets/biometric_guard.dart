import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_state.dart';

class BiometricGuard extends StatefulWidget {
  final Widget child;

  const BiometricGuard({super.key, required this.child});

  @override
  State<BiometricGuard> createState() => _BiometricGuardState();
}

class _BiometricGuardState extends State<BiometricGuard> with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuth();
    } else if (state == AppLifecycleState.paused) {
      // Re-lock the app when sent to background
      final useBiometrics = context.read<SettingsBloc>().state.useBiometrics;
      if (useBiometrics && _isAuthenticated) {
        setState(() {
          _isAuthenticated = false;
        });
      }
    }
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;
    
    final useBiometrics = context.read<SettingsBloc>().state.useBiometrics;
    if (!useBiometrics) {
      if (!_isAuthenticated) {
        setState(() => _isAuthenticated = true);
      }
      return;
    }

    if (_isAuthenticated || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    bool authenticated = false;
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (canCheckBiometrics || isDeviceSupported) {
        authenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to unlock Kharch Tracker',
          persistAcrossBackgrounding: true,
          biometricOnly: false,
        );
      } else {
        authenticated = true; // Fallback if device doesn't support biometrics
      }
    } on PlatformException catch (_) {
      authenticated = false;
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticated = authenticated;
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (!state.useBiometrics || _isAuthenticated) {
          return widget.child;
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Scaffold(
          body: Container(
            width: double.infinity,
            color: isDark ? AppColors.darkBackground : AppColors.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'App Locked',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kharch Tracker is locked for your security.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                if (!_isAuthenticating)
                  ElevatedButton.icon(
                    onPressed: _checkAuth,
                    icon: const Icon(Icons.fingerprint_rounded),
                    label: const Text('Unlock App'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
