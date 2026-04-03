import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/utils/currency_utils.dart';
import 'package:finance_tracker/data/models/category_model.dart';

class CategoryBreakdownChart extends StatefulWidget {
  final Map<String, double> breakdown;
  final String currencySymbol;

  const CategoryBreakdownChart({
    super.key,
    required this.breakdown,
    this.currencySymbol = '₹',
  });

  @override
  State<CategoryBreakdownChart> createState() => _CategoryBreakdownChartState();
}

class _CategoryBreakdownChartState extends State<CategoryBreakdownChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.breakdown.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No spending data to show',
              style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    final total = widget.breakdown.values.fold<double>(0, (a, b) => a + b);
    final entries = widget.breakdown.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
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
                            setState(() =>
                                _touchedIndex = response.touchedSection!.touchedSectionIndex);
                          } else {
                            setState(() => _touchedIndex = -1);
                          }
                        },
                      ),
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                      sections: entries.asMap().entries.map((entry) {
                        final i = entry.key;
                        final e = entry.value;
                        final isTouched = i == _touchedIndex;
                        final color = AppColors.chartColors[i % AppColors.chartColors.length];
                        return PieChartSectionData(
                          value: e.value,
                          color: color,
                          radius: isTouched ? 44 : 36,
                          showTitle: isTouched,
                          title: isTouched
                              ? '${(e.value / total * 100).toStringAsFixed(0)}%'
                              : '',
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          titlePositionPercentageOffset: 0.55,
                          borderSide: isTouched
                              ? BorderSide(color: Colors.white, width: 2.5)
                              : BorderSide.none,
                        );
                      }).toList(),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 300),
                    swapAnimationCurve: Curves.easeOutCubic,
                  ),
                  // Center label
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: _touchedIndex >= 0 && _touchedIndex < entries.length
                        ? Column(
                            key: ValueKey(_touchedIndex),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                entries[_touchedIndex].key,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                CurrencyUtils.formatAmountCompact(
                                  entries[_touchedIndex].value,
                                  symbol: widget.currencySymbol,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.chartColors[
                                      _touchedIndex % AppColors.chartColors.length],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            key: const ValueKey('total'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                CurrencyUtils.formatAmountCompact(total, symbol: widget.currencySymbol),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...entries.asMap().entries.map((entry) {
              final i = entry.key;
              final e = entry.value;
              final percentage = total > 0 ? (e.value / total * 100) : 0.0;
              final color = AppColors.chartColors[i % AppColors.chartColors.length];
              final cat = CategoryModel.getCategoryByName(e.key);
              final isTouched = i == _touchedIndex;

              return GestureDetector(
                onTap: () {
                  setState(() => _touchedIndex = _touchedIndex == i ? -1 : i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.symmetric(
                    vertical: isTouched ? 10 : 6,
                    horizontal: isTouched ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isTouched ? color.withOpacity(0.06) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isTouched
                        ? Border.all(color: color.withOpacity(0.15))
                        : null,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isTouched ? 40 : 36,
                        height: isTouched ? 40 : 36,
                        decoration: BoxDecoration(
                          color: color.withOpacity(isTouched ? 0.2 : 0.12),
                          borderRadius: BorderRadius.circular(isTouched ? 12 : 10),
                        ),
                        child: Icon(cat.icon, color: color, size: isTouched ? 20 : 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isTouched ? FontWeight.w700 : FontWeight.w600,
                                color: isTouched
                                    ? color
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: percentage / 100),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.divider,
                                    valueColor: AlwaysStoppedAnimation(color),
                                    minHeight: isTouched ? 6 : 4,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyUtils.formatAmountCompact(e.value, symbol: widget.currencySymbol),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isTouched
                                  ? color
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
