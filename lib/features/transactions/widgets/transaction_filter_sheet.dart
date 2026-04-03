import 'package:flutter/material.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/data/models/category_model.dart';
import 'package:finance_tracker/core/utils/date_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionFilterSheet extends StatefulWidget {
  final TransactionType? currentType;
  final String? currentCategory;
  final DateTime? currentStartDate;
  final DateTime? currentEndDate;
  final Function(TransactionType?, String?, DateTime?, DateTime?) onApply;
  final VoidCallback onClear;

  const TransactionFilterSheet({
    super.key,
    this.currentType,
    this.currentCategory,
    this.currentStartDate,
    this.currentEndDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  TransactionType? _type;
  String? _category;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _type = widget.currentType;
    _category = widget.currentCategory;
    _startDate = widget.currentStartDate;
    _endDate = widget.currentEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = _type == TransactionType.income
        ? CategoryModel.incomeCategories
        : CategoryModel.expenseCategories;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {
                  widget.onClear();
                  Navigator.pop(context);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Type filter
          Text(
            'Type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: _type == null,
                onTap: () => setState(() {
                  _type = null;
                  _category = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Income',
                isSelected: _type == TransactionType.income,
                color: AppColors.income,
                onTap: () => setState(() {
                  _type = TransactionType.income;
                  _category = null;
                }),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Expense',
                isSelected: _type == TransactionType.expense,
                color: AppColors.expense,
                onTap: () => setState(() {
                  _type = TransactionType.expense;
                  _category = null;
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category filter
          if (_type != null) ...[
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((c) {
                return _FilterChip(
                  label: c.name,
                  isSelected: _category == c.name,
                  color: c.color,
                  onTap: () => setState(() {
                    _category = _category == c.name ? null : c.name;
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Date range
          Text(
            'Date Range',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DateButton(
                  label: _startDate != null ? AppDateUtils.formatDateShort(_startDate!) : 'Start Date',
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _startDate = date);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateButton(
                  label: _endDate != null ? AppDateUtils.formatDateShort(_endDate!) : 'End Date',
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _endDate = DateTime(date.year, date.month, date.day, 23, 59, 59));
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_type, _category, _startDate, _endDate);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? activeColor : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
