part of 'workflow_bloc.dart';

abstract class WorkflowEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// To switch between the tabs 
class ButtonClicked extends WorkflowEvent {
  final int index;
  ButtonClicked({required this.index});

  @override
  List<Object> get props => [index];
}

// Gets the pending quality check tasks 
class GetQualityCheckTasks extends WorkflowEvent {
  final int facilityID;
  final int page;
  GetQualityCheckTasks({required this.facilityID,required this.page});

  @override
  List<Object> get props => [facilityID, page];
}


// Gets the completed quality check tasks 
class GetCompletedQualityCheckTasks extends WorkflowEvent {
  final int page;
  GetCompletedQualityCheckTasks({required this.page});

  @override
  List<Object> get props => [page];
}

// To send post request for the selected qualityCheck tasks 
// approveStatus -> true for approve 
// approveStatus -> false for reject  
class PostQualityCheckTasks extends WorkflowEvent {
  final bool approveStatus;
  PostQualityCheckTasks({required this.approveStatus});
}


// To add or remove quality check tasks from selection.
class QualityCheckStatusUpdate extends WorkflowEvent {
  final List<String> lpnNbr;
  final bool isChecked; // if true adds the lpnNbrs to selectedList of LpnNbrs (selectedQaulityCheckTasks) 
  QualityCheckStatusUpdate({required this.lpnNbr,required this.isChecked});

  @override
  List<Object> get props => [lpnNbr,isChecked];
}

class GetCycleCountTasks extends WorkflowEvent {
  final int facilityID;
  GetCycleCountTasks({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

class CycleCountStatusUpdated extends WorkflowEvent {
  final String task;
  final bool isChecked;
  CycleCountStatusUpdated({required this.task, required this.isChecked});

  @override
  List<Object> get props => [task, isChecked];
}

class SelectAllCycleCountTasks extends WorkflowEvent {
  final bool isChecked;
  SelectAllCycleCountTasks({required this.isChecked});

  @override
  List<Object> get props => [isChecked];
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

