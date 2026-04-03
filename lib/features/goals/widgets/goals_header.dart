import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsHeader extends StatelessWidget {
  final VoidCallback onMarkSaved;

  const GoalsHeader({super.key, required this.onMarkSaved});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Goals',
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: onMarkSaved,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🔥', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 6),
                  Text(
                    'Mark Saved',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFFF6B35)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
