import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kharch Tracker',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _IconButton(
                icon: Icons.add_rounded,
                onTap: () => context.push('/transactions/add'),
                isPrimary: true,
              ),
              const SizedBox(width: 8),
              _IconButton(
                icon: Icons.settings_rounded,
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 👋';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _IconButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : (isDark ? AppColors.darkCard : AppColors.surface),
          borderRadius: BorderRadius.circular(14),
          border: isPrimary ? null : Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          boxShadow: isPrimary
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isPrimary ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        ),
      ),
    );
  }
}
