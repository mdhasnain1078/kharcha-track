import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';

class PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PeriodSelector({
    super.key,
    required this.periods,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.divider,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: periods.asMap().entries.map((entry) {
            final isSelected = entry.key == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.darkSurface : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                            : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
