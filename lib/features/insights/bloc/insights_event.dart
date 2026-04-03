import 'package:equatable/equatable.dart';

abstract class InsightsEvent extends Equatable {
  const InsightsEvent();
  @override
  List<Object?> get props => [];
}

class LoadInsights extends InsightsEvent {}

class ChangeInsightsPeriod extends InsightsEvent {
  final int periodIndex; // 0=Week, 1=Month, 2=All
  const ChangeInsightsPeriod(this.periodIndex);
  @override
  List<Object?> get props => [periodIndex];
}
