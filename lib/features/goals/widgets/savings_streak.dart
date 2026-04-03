import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/constants/app_constants.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SavingsStreak extends StatelessWidget {
  final int streak;

  const SavingsStreak({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final message = AppConstants.getStreakMessage(streak);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: streak > 0
              ? [const Color(0xFFFF9A3C), const Color(0xFFFF6B35)]
              : [
                  isDark ? AppColors.darkCard : AppColors.surface,
                  isDark ? AppColors.darkCard : AppColors.surface,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: streak == 0
            ? Border.all(color: isDark ? AppColors.darkBorder : AppColors.border)
            : null,
        boxShadow: streak > 0
            ? [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: streak > 0
                  ? Colors.white.withOpacity(0.2)
                  : (isDark ? AppColors.darkBorder : AppColors.border).withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                streak > 0 ? '🔥' : '💡',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          )
              .animate(
                onPlay: (controller) => streak > 3 ? controller.repeat() : null,
              )
              .shake(
                hz: 2,
                duration: streak > 3 ? 1000.ms : 0.ms,
                delay: 2000.ms,
              ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak > 0 ? '$streak Day Streak!' : 'Start Your Streak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: streak > 0
                        ? Colors.white
                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: streak > 0
                        ? Colors.white.withOpacity(0.8)
                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
