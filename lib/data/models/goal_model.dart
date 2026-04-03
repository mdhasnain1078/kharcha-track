import 'package:equatable/equatable.dart';

class GoalModel extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final int iconCodePoint;
  final int color;
  final bool isCompleted;
  final DateTime createdAt;

  const GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    required this.iconCodePoint,
    required this.color,
    this.isCompleted = false,
    required this.createdAt,
  });

  double get progress => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  double get remainingAmount => (targetAmount - savedAmount).clamp(0.0, double.infinity);

  int get daysRemaining {
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  bool get isOverdue => daysRemaining < 0 && !isCompleted;

  double get dailySavingsNeeded {
    if (daysRemaining <= 0) return remainingAmount;
    return remainingAmount / daysRemaining;
  }

  GoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
    int? iconCodePoint,
    int? color,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: deadline ?? this.deadline,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'target_amount': targetAmount,
      'saved_amount': savedAmount,
      'deadline': deadline.toIso8601String(),
      'icon_code_point': iconCodePoint,
      'color': color,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      savedAmount: (map['saved_amount'] as num).toDouble(),
      deadline: DateTime.parse(map['deadline'] as String),
      iconCodePoint: map['icon_code_point'] as int,
      color: map['color'] as int,
      isCompleted: (map['is_completed'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, title, targetAmount, savedAmount, deadline, iconCodePoint, color, isCompleted, createdAt];
}
