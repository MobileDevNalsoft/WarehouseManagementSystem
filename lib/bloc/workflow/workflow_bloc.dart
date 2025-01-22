import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/models/task_model.dart';

part 'workflow_event.dart';
part 'workflow_state.dart';

class WorkflowBloc extends Bloc<WorkflowEvent, WorkflowState> {
  WorkflowBloc() : super(WorkflowState.initial()) {
    on<QualityCheckStatusUpdated>(_onQualityCheckStatusUpdated);
    on<CycleCountStatusUpdated>(_onCycleCountStatusUpdated);
    on<SelectAllQualityCheckTasks>(_onSelectAllQualityCheckTasks);
    on<SelectAllCycleCountTasks>(_onSelectAllCycleCountTasks);
    on<ButtonClicked>(_onButtonClicked);
    on<QualityCheckTasksUpdated>(_onQualityCheckTasksUpdated);
    on<CycleCountTasksUpdated>(_onCycleCountTasksUpdated);
  }

  void _onQualityCheckStatusUpdated(QualityCheckStatusUpdated event, Emitter<WorkflowState> emit) {
    state.qualityCheckTasks.where((task) => task.lpnNbr == event.lpnNbr).first.isChecked = event.isChecked;
    emit(state.copyWith(qualityCheckTasks: state.qualityCheckTasks));
  }

  void _onCycleCountStatusUpdated(CycleCountStatusUpdated event, Emitter<WorkflowState> emit) {
    state.cycleCountTasks.where((task) => task.task == event.task).first.isChecked = event.isChecked;
    emit(state.copyWith(cycleCountTasks: state.cycleCountTasks));
  }

  void _onSelectAllQualityCheckTasks(SelectAllQualityCheckTasks event, Emitter<WorkflowState> emit) {
    state.qualityCheckTasks.forEach((task) {
      task.isChecked = event.isChecked;
    });
    emit(state.copyWith(selectedAllQualityCheckTasks: event.isChecked));
  }

  void _onSelectAllCycleCountTasks(SelectAllCycleCountTasks event, Emitter<WorkflowState> emit) {
    state.cycleCountTasks.forEach((task) {
      task.isChecked = event.isChecked;
    });
    emit(state.copyWith(selectedAllCycleCountTasks: event.isChecked));
  }

  void _onButtonClicked(ButtonClicked event, Emitter<WorkflowState> emit) {
    emit(state.copyWith(buttonIndex: event.index));
  }

  void _onQualityCheckTasksUpdated(QualityCheckTasksUpdated event, Emitter<WorkflowState> emit) {
    for (int i = 0; i < event.tasks.length; i++) {
      state.qualityCheckTasks.where((task) => task.lpnNbr == event.tasks[i]).first.qcStatus = event.qcStatus;
    }
    emit(state.copyWith(qualityCheckTasks: state.qualityCheckTasks));
  }

  void _onCycleCountTasksUpdated(CycleCountTasksUpdated event, Emitter<WorkflowState> emit) {
    for (int i = 0; i < event.tasks.length; i++) {
      state.cycleCountTasks.where((task) => task.task == event.tasks[i]).first.status = event.ccStatus;
    }
    emit(state.copyWith(cycleCountTasks: state.cycleCountTasks));
  }
}
