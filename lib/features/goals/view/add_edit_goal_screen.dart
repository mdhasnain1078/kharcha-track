import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:finance_tracker/core/theme/app_colors.dart';
import 'package:finance_tracker/core/extensions/context_extensions.dart';
import 'package:finance_tracker/core/utils/validators.dart';
import 'package:finance_tracker/core/constants/app_constants.dart';
import 'package:finance_tracker/data/models/goal_model.dart';
import 'package:finance_tracker/data/repositories/goal_repository.dart';
import 'package:finance_tracker/features/goals/bloc/goal_bloc.dart';
import 'package:finance_tracker/features/goals/bloc/goal_event.dart';
import 'package:finance_tracker/features/home/bloc/home_bloc.dart';
import 'package:finance_tracker/features/home/bloc/home_event.dart';
import 'package:finance_tracker/features/goals/widgets/goal_preview_card.dart';
import 'package:finance_tracker/features/goals/widgets/goal_icon_picker.dart';
import 'package:finance_tracker/features/goals/widgets/goal_color_picker.dart';
import 'package:finance_tracker/shared/widgets/field_label.dart';
import 'package:finance_tracker/shared/widgets/date_picker_tile.dart';
import 'package:finance_tracker/shared/widgets/confirm_dialog.dart';

class AddEditGoalScreen extends StatefulWidget {
  final String? goalId;

  const AddEditGoalScreen({super.key, this.goalId});

  @override
  State<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends State<AddEditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));
  int _selectedIconIndex = 0;
  int _selectedColorIndex = 0;
  bool _isEditing = false;
  bool _isLoading = true;
  GoalModel? _existingGoal;

  @override
  void initState() {
    super.initState();
    if (widget.goalId != null) {
      _isEditing = true;
      _loadGoal();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadGoal() async {
    final goal = await GoalRepository().getGoalById(widget.goalId!);
    if (goal != null && mounted) {
      setState(() {
        _existingGoal = goal;
        _titleController.text = goal.title;
        _amountController.text = goal.targetAmount.toString();
        _deadline = goal.deadline;
        _selectedIconIndex = _getIndex(AppConstants.goalIcons.map((i) => i.codePoint), goal.iconCodePoint);
        _selectedColorIndex = _getIndex(AppConstants.goalColors.map((c) => c.value), goal.color);
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  int _getIndex<T>(Iterable<T> items, T match) {
    final index = items.toList().indexOf(match);
    return index >= 0 ? index : 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Goal' : 'New Goal'),
        actions: [
          if (_isEditing)
            IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.expense), onPressed: _deleteGoal),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoalPreviewCard(
                icon: AppConstants.goalIcons[_selectedIconIndex],
                color: AppConstants.goalColors[_selectedColorIndex],
                title: _titleController.text.isNotEmpty ? _titleController.text : 'My Goal',
              ),
              const SizedBox(height: 28),
              const FieldLabel(label: 'Goal Name'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController, validator: Validators.validateTitle,
                onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'e.g. New iPhone, Vacation Fund'),
              ),
              const SizedBox(height: 24),
              const FieldLabel(label: 'Target Amount'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                validator: (v) => Validators.validateGoalAmount(v, currentSaved: _existingGoal?.savedAmount),
                decoration: const InputDecoration(hintText: '0', prefixText: '₹ '),
              ),
              const SizedBox(height: 24),
              const FieldLabel(label: 'Target Date'),
              const SizedBox(height: 10),
              DatePickerTile(date: _deadline, onTap: _pickDeadline),
              const SizedBox(height: 24),
              const FieldLabel(label: 'Icon'),
              const SizedBox(height: 10),
              GoalIconPicker(selectedIconIndex: _selectedIconIndex, selectedColorIndex: _selectedColorIndex, onIconSelected: (i) => setState(() => _selectedIconIndex = i)),
              const SizedBox(height: 24),
              const FieldLabel(label: 'Color'),
              const SizedBox(height: 10),
              GoalColorPicker(selectedColorIndex: _selectedColorIndex, onColorSelected: (i) => setState(() => _selectedColorIndex = i)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(onPressed: _saveGoal, child: Text(_isEditing ? 'Update Goal' : 'Create Goal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(context: context, initialDate: _deadline, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 3650)));
    if (date != null) setState(() => _deadline = date);
  }

  void _saveGoal() {
    if (!_formKey.currentState!.validate()) return;
    final icon = AppConstants.goalIcons[_selectedIconIndex];
    final color = AppConstants.goalColors[_selectedColorIndex];

    if (_isEditing && _existingGoal != null) {
      context.read<GoalBloc>().add(UpdateGoal(_existingGoal!.copyWith(
        title: _titleController.text.trim(), targetAmount: double.parse(_amountController.text.trim()),
        deadline: _deadline, iconCodePoint: icon.codePoint, color: color.value,
      )));
      context.showSuccessSnackBar('Goal updated');
    } else {
      context.read<GoalBloc>().add(AddGoal(GoalModel(
        id: const Uuid().v4(), title: _titleController.text.trim(), targetAmount: double.parse(_amountController.text.trim()),
        savedAmount: 0, deadline: _deadline, iconCodePoint: icon.codePoint, color: color.value, createdAt: DateTime.now(),
      )));
      context.showSuccessSnackBar('Goal created! 🎯');
    }
    context.read<HomeBloc>().add(RefreshDashboard());
    context.pop();
  }

  void _deleteGoal() async {
    final confirmed = await showConfirmDialog(context: context, title: 'Delete Goal?', message: 'This will permanently delete this goal and its progress.');
    if (confirmed && mounted) {
      context.read<GoalBloc>().add(DeleteGoal(widget.goalId!));
      context.read<HomeBloc>().add(RefreshDashboard());
      context.showSuccessSnackBar('Goal deleted');
      context.pop();
    }
  }
}
