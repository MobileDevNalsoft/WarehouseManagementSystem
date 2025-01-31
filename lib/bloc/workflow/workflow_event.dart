part of 'workflow_bloc.dart';

abstract class WorkflowEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQualityCheckTasks extends WorkflowEvent {
  final int facilityID;
  GetQualityCheckTasks({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

class GetCycleCountTasks extends WorkflowEvent {
  final int facilityID;
  GetCycleCountTasks({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

class QualityCheckStatusUpdated extends WorkflowEvent {
  final List<String> lpnNbr;
  bool isChecked;
  QualityCheckStatusUpdated({required this.lpnNbr,required this.isChecked});

  @override
  List<Object> get props => [lpnNbr,isChecked];
}

class CycleCountStatusUpdated extends WorkflowEvent {
  final String task;
  final bool isChecked;
  CycleCountStatusUpdated({required this.task, required this.isChecked});

  @override
  List<Object> get props => [task, isChecked];
}

class SelectAllQualityCheckTasks extends WorkflowEvent {
  final bool isChecked;
  SelectAllQualityCheckTasks({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}

class SelectAllCycleCountTasks extends WorkflowEvent {
  final bool isChecked;
  SelectAllCycleCountTasks({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
}

class ButtonClicked extends WorkflowEvent {
  final int index;
  ButtonClicked({required this.index});

  @override
  List<Object> get props => [index];
}

class QualityCheckTasksUpdated extends WorkflowEvent {
  final List<String> tasks;
  String qcStatus;
  QualityCheckTasksUpdated({required this.tasks, required this.qcStatus});

  @override
  List<Object> get props => [tasks, qcStatus];
}

class CycleCountTasksUpdated extends WorkflowEvent {
  final List<String> tasks;
  String ccStatus;
  CycleCountTasksUpdated({required this.tasks, required this.ccStatus});

  @override
  List<Object> get props => [tasks, ccStatus];
}


class PostQualityCheckTasks extends WorkflowEvent {
  
  bool approveStatus;
  PostQualityCheckTasks({required this.approveStatus});

  @override
  List<Object> get props => [approveStatus];
}

class GetCompletedQualityCheckTasks extends WorkflowEvent {
  GetCompletedQualityCheckTasks();

}