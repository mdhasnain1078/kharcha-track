import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeeklyTrendChart extends StatefulWidget {
  final Map<String, double> categoryBreakdown;

  const WeeklyTrendChart({super.key, required this.categoryBreakdown});

  @override
  State<WeeklyTrendChart> createState() => _WeeklyTrendChartState();
}

class _WeeklyTrendChartState extends State<WeeklyTrendChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.categoryBreakdown.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories This Month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'No expenses yet this month',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    }

    final total = widget.categoryBreakdown.values.fold<double>(0, (a, b) => a + b);
    final entries = widget.categoryBreakdown.entries.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories This Month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              enabled: true,
                              touchCallback: (event, response) {
                                if (event.isInterestedForInteractions &&
                                    response != null &&
                                    response.touchedSection != null) {
                                  setState(() => _touchedIndex =
                                      response.touchedSection!.touchedSectionIndex);
                                } else {
                                  setState(() => _touchedIndex = -1);
                                }
                              },
                            ),
                            sectionsSpace: 2,
                            centerSpaceRadius: 32,
                            sections: entries.asMap().entries.map((entry) {
                              final i = entry.key;
                              final e = entry.value;
                              final isTouched = i == _touchedIndex;
                              final color = AppColors.chartColors[i % AppColors.chartColors.length];
                              return PieChartSectionData(
                                value: e.value,
                                color: color,
                                radius: isTouched ? 34 : 28,
                                showTitle: false,
                                borderSide: isTouched
                                    ? BorderSide(color: Colors.white, width: 2)
                                    : BorderSide.none,
                              );
                            }).toList(),
                          ),
                          swapAnimationDuration: const Duration(milliseconds: 250),
                          swapAnimationCurve: Curves.easeOutCubic,
                        ),
                        // Center percentage
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: _touchedIndex >= 0 && _touchedIndex < entries.length
                              ? Text(
                                  '${(entries[_touchedIndex].value / total * 100).toStringAsFixed(0)}%',
                                  key: ValueKey(_touchedIndex),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.chartColors[
                                        _touchedIndex % AppColors.chartColors.length],
                                  ),
                                )
                              : Icon(
                                  Icons.donut_large_rounded,
                                  key: const ValueKey('icon'),
                                  size: 20,
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: entries.asMap().entries.map((entry) {
                        final i = entry.key;
                        final e = entry.value;
                        final percentage = total > 0 ? (e.value / total * 100) : 0.0;
                        final isTouched = i == _touchedIndex;
                        final color = AppColors.chartColors[i % AppColors.chartColors.length];

                        return GestureDetector(
                          onTap: () => setState(
                              () => _touchedIndex = _touchedIndex == i ? -1 : i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              vertical: isTouched ? 6 : 4,
                              horizontal: isTouched ? 8 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: isTouched ? color.withOpacity(0.08) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isTouched ? 12 : 10,
                                  height: isTouched ? 12 : 10,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(isTouched ? 4 : 3),
                                    boxShadow: isTouched
                                        ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 4)]
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    e.key,
                                    style: TextStyle(
                                      fontSize: isTouched ? 13 : 12,
                                      fontWeight: isTouched ? FontWeight.w700 : FontWeight.w500,
                                      color: isTouched
                                          ? color
                                          : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isTouched
                                        ? color
                                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
