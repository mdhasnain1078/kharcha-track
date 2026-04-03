import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/core/utils/validators.dart';
import 'package:finance_tracker/data/models/transaction_model.dart';
import 'package:finance_tracker/data/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_bloc.dart';
import 'package:finance_tracker/features/transactions/bloc/transaction_event.dart';
import 'package:finance_tracker/features/transactions/widgets/category_picker.dart';
import 'package:finance_tracker/features/transactions/widgets/amount_input_field.dart';
import 'package:finance_tracker/features/home/bloc/home_bloc.dart';
import 'package:finance_tracker/features/home/bloc/home_event.dart';
import 'package:finance_tracker/shared/widgets/type_toggle.dart';
import 'package:finance_tracker/shared/widgets/field_label.dart';
import 'package:finance_tracker/shared/widgets/date_picker_tile.dart';
import 'package:finance_tracker/shared/widgets/confirm_dialog.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final String? transactionId;

  const AddEditTransactionScreen({super.key, this.transactionId});

  @override
  State<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String? _category;
  DateTime _date = DateTime.now();
  bool _isEditing = false;
  bool _isLoading = true;
  TransactionModel? _existingTransaction;

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      _isEditing = true;
      _loadTransaction();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadTransaction() async {
    final transaction = await TransactionRepository().getTransactionById(widget.transactionId!);
    if (transaction != null && mounted) {
      setState(() {
        _existingTransaction = transaction;
        _amountController.text = transaction.amount.toString();
        _noteController.text = transaction.note ?? '';
        _type = transaction.type;
        _category = transaction.category;
        _date = transaction.date;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
        actions: [
          if (_isEditing)
            IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.expense), onPressed: _deleteTransaction),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeToggle(
                leftLabel: 'Expense', rightLabel: 'Income',
                leftIcon: Icons.arrow_upward_rounded, rightIcon: Icons.arrow_downward_rounded,
                leftColor: AppColors.expense, rightColor: AppColors.income,
                isLeftSelected: _type == TransactionType.expense,
                onChanged: (isLeft) => setState(() { _type = isLeft ? TransactionType.expense : TransactionType.income; _category = null; }),
              ),
              const SizedBox(height: 32),
              AmountInputField(controller: _amountController, validator: Validators.validateAmount),
              const SizedBox(height: 32),
              const FieldLabel(label: 'Category'),
              const SizedBox(height: 12),
              CategoryPicker(type: _type, selectedCategory: _category, onSelected: (cat) => setState(() => _category = cat)),
              if (_category == null)
                Padding(padding: const EdgeInsets.only(top: 8), child: Text('Please select a category', style: TextStyle(fontSize: 12, color: AppColors.expense))),
              const SizedBox(height: 24),
              const FieldLabel(label: 'Date'),
              const SizedBox(height: 12),
              DatePickerTile(date: _date, onTap: _pickDate),
              const SizedBox(height: 24),
              const FieldLabel(label: 'Note (Optional)'),
              const SizedBox(height: 12),
              TextFormField(controller: _noteController, validator: Validators.validateNote, maxLines: 3, decoration: const InputDecoration(hintText: 'Add a note...')),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(onPressed: _saveTransaction, child: Text(_isEditing ? 'Update Transaction' : 'Save Transaction', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
    if (date != null) setState(() => _date = date);
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null) { context.showSnackBar('Please select a category', isError: true); return; }
    final amount = double.parse(_amountController.text.trim());
    if (_isEditing && _existingTransaction != null) {
      context.read<TransactionBloc>().add(UpdateTransaction(_existingTransaction!.copyWith(amount: amount, type: _type, category: _category, date: _date, note: _noteController.text.isNotEmpty ? _noteController.text.trim() : null)));
      context.showSuccessSnackBar('Transaction updated');
    } else {
      context.read<TransactionBloc>().add(AddTransaction(TransactionModel(id: const Uuid().v4(), amount: amount, type: _type, category: _category!, date: _date, note: _noteController.text.isNotEmpty ? _noteController.text.trim() : null, createdAt: DateTime.now())));
      context.showSuccessSnackBar('Transaction added');
    }
    context.read<HomeBloc>().add(RefreshDashboard());
    context.pop();
  }

  void _deleteTransaction() async {
    final confirmed = await showConfirmDialog(context: context, title: 'Delete Transaction?', message: 'This action cannot be undone.');
    if (confirmed && mounted) {
      context.read<TransactionBloc>().add(DeleteTransaction(widget.transactionId!));
      context.read<HomeBloc>().add(RefreshDashboard());
      context.showSuccessSnackBar('Transaction deleted');
      context.pop();
    }
  }
}
