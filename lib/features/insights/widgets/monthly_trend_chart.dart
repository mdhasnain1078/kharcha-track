import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';

class MonthlyTrendChart extends StatefulWidget {
  final Map<String, double> monthlyTrend;
  final String currencySymbol;

  const MonthlyTrendChart({super.key, required this.monthlyTrend, required this.currencySymbol});

  @override
  State<MonthlyTrendChart> createState() => _MonthlyTrendChartState();
}

class _MonthlyTrendChartState extends State<MonthlyTrendChart>
    with SingleTickerProviderStateMixin {
  int _touchedSpotIndex = -1;
  late AnimationController _animController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _lineAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.monthlyTrend.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = widget.monthlyTrend.entries.toList();
    final maxY = entries.fold<double>(0, (a, e) => a > e.value ? a : e.value);
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

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
                  'Monthly Trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                if (_touchedSpotIndex >= 0 && _touchedSpotIndex < entries.length)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      key: ValueKey(_touchedSpotIndex),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        CurrencyUtils.formatAmountCompact(entries[_touchedSpotIndex].value, symbol: widget.currencySymbol),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _lineAnimation,
                builder: (context, _) {
                  final spots = entries.asMap().entries.map((e) {
                    return FlSpot(
                      e.key.toDouble(),
                      e.value.value * _lineAnimation.value,
                    );
                  }).toList();

                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY > 0 ? maxY / 4 : 1000,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: isDark
                              ? AppColors.darkBorder.withOpacity(0.3)
                              : AppColors.divider.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [6, 4],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= entries.length) return const SizedBox();
                              final parts = entries[idx].key.split('/');
                              final monthIdx = int.tryParse(parts[0]) ?? 0;
                              final isTouched = idx == _touchedSpotIndex;
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  monthIdx < months.length ? months[monthIdx] : '',
                                  style: TextStyle(
                                    fontSize: isTouched ? 12 : 11,
                                    fontWeight: isTouched ? FontWeight.w700 : FontWeight.w500,
                                    color: isTouched
                                        ? AppColors.primary
                                        : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: maxY > 0 ? maxY * 1.2 : 1000,
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: false,
                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions &&
                              response != null &&
                              response.lineBarSpots != null &&
                              response.lineBarSpots!.isNotEmpty) {
                            setState(() => _touchedSpotIndex = response.lineBarSpots!.first.spotIndex);
                          } else if (!event.isInterestedForInteractions) {
                            setState(() => _touchedSpotIndex = -1);
                          }
                        },
                        getTouchedSpotIndicator: (barData, spotIndexes) {
                          return spotIndexes.map((index) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color: AppColors.primary.withOpacity(0.3),
                                strokeWidth: 1.5,
                                dashArray: [4, 4],
                              ),
                              FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, idx) {
                                  return FlDotCirclePainter(
                                    radius: 7,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: AppColors.primary,
                                  );
                                },
                              ),
                            );
                          }).toList();
                        },
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) {
                            return isDark
                                ? const Color(0xFF2A2D3E)
                                : const Color(0xFF1E1E2C);
                          },
                          tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          tooltipRoundedRadius: 12,
                          tooltipBorder: BorderSide(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                          getTooltipItems: (spots) {
                            final months = [
                              '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                            ];
                            return spots.map((spot) {
                              final idx = spot.spotIndex;
                              String monthLabel = '';
                              if (idx >= 0 && idx < entries.length) {
                                final parts = entries[idx].key.split('/');
                                final monthIdx = int.tryParse(parts[0]) ?? 0;
                                if (monthIdx < months.length) monthLabel = months[monthIdx];
                              }
                              return LineTooltipItem(
                                '$monthLabel\n',
                                TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                                children: [
                                  TextSpan(
                                    text: CurrencyUtils.formatAmountCompact(spot.y, symbol: widget.currencySymbol),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) {
                              final isTouched = index == _touchedSpotIndex;
                              return FlDotCirclePainter(
                                radius: isTouched ? 6 : 4,
                                color: isTouched ? AppColors.primary : Colors.white,
                                strokeWidth: 2.5,
                                strokeColor: AppColors.primary,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.2 * _lineAnimation.value),
                                AppColors.accent.withOpacity(0.05 * _lineAnimation.value),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
