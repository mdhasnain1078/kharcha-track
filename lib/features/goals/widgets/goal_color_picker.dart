import 'package:flutter/material.dart';
import 'package:finance_tracker/core/constants/app_constants.dart';

class GoalColorPicker extends StatelessWidget {
  final int selectedColorIndex;
  final ValueChanged<int> onColorSelected;

  const GoalColorPicker({
    super.key,
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: AppConstants.goalColors.asMap().entries.map((entry) {
        final isSelected = entry.key == selectedColorIndex;
        return GestureDetector(
          onTap: () => onColorSelected(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.value,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: entry.value.withOpacity(0.4), blurRadius: 8)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
