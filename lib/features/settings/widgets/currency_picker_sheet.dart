import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/features/settings/bloc/settings_bloc.dart';
import 'package:finance_tracker/features/settings/bloc/settings_event.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyPickerSheet extends StatelessWidget {
  final String currentCurrency;

  const CurrencyPickerSheet({super.key, required this.currentCurrency});

  static void show(BuildContext context, String current) {
    showModalBottomSheet(
      context: context,
      builder: (_) => CurrencyPickerSheet(currentCurrency: current),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencies = ['₹', '\$', '€', '£', '¥', '₩'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Currency',
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: currencies.map((c) {
              final isSelected = c == currentCurrency;
              return GestureDetector(
                onTap: () {
                  context.read<SettingsBloc>().add(ChangeCurrency(c));
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      c,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
