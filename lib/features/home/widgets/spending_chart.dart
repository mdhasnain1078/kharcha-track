import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpendingChart extends StatefulWidget {
  final Map<int, double> weeklySpending;
  final String currencySymbol;

  const SpendingChart({super.key, required this.weeklySpending, required this.currencySymbol});

  @override
  State<SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<SpendingChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxValue = widget.weeklySpending.values.fold<double>(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Spending',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                // Show total
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    CurrencyUtils.formatAmountCompact(
                        widget.weeklySpending.values.fold<double>(0, (a, b) => a + b),
                        symbol: widget.currencySymbol),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue > 0 ? maxValue * 1.3 : 1000,
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() => _touchedIndex = response.spot!.touchedBarGroupIndex);
                      } else {
                        setState(() => _touchedIndex = -1);
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipColor: (group) {
                        return isDark
                            ? const Color(0xFF2A2D3E)
                            : const Color(0xFF1E1E2C);
                      },
                      tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      tooltipMargin: 8,
                      tooltipRoundedRadius: 12,
                      tooltipBorder: BorderSide(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (_touchedIndex != groupIndex) return null;
                        final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][groupIndex];
                        final actualValue = widget.weeklySpending[groupIndex] ?? 0;
                        return BarTooltipItem(
                          '$day\n',
                          TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                          children: [
                            TextSpan(
                              text: CurrencyUtils.formatAmountCompact(actualValue, symbol: widget.currencySymbol),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= days.length) return const SizedBox();
                          final isToday = idx == DateTime.now().weekday - 1;
                          final isTouched = idx == _touchedIndex;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: isTouched ? 13 : 12,
                                fontWeight: (isToday || isTouched) ? FontWeight.w700 : FontWeight.w500,
                                color: isTouched
                                    ? AppColors.primary
                                    : isToday
                                        ? AppColors.primary
                                        : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                              ),
                              child: Text(days[idx]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (i) {
                    final value = widget.weeklySpending[i] ?? 0;
                    final isToday = i == DateTime.now().weekday - 1;
                    final isTouched = i == _touchedIndex;
                    return BarChartGroupData(
                      x: i,
                      showingTooltipIndicators: isTouched ? [0] : [],
                      barRods: [
                        BarChartRodData(
                          toY: isTouched ? (value > 0 ? value * 1.04 : 0) : (value > 0 ? value : 0),
                          gradient: isTouched
                              ? const LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                )
                              : null,
                          color: isTouched
                              ? null
                              : isToday
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.25),
                          width: isTouched ? 32 : 28,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(isTouched ? 10 : 8),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxValue > 0 ? maxValue * 1.3 : 1000,
                            color: isDark
                                ? AppColors.darkBorder.withOpacity(0.3)
                                : AppColors.divider,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                swapAnimationDuration: const Duration(milliseconds: 250),
                swapAnimationCurve: Curves.easeOutCubic,
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
