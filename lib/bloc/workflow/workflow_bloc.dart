import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/local_network_calls.dart';
import 'package:wmssimulator/logger/logger.dart';
import 'package:wmssimulator/models/task_model.dart';

import '../../models/area_response.dart';

part 'workflow_event.dart';
part 'workflow_state.dart';

class WorkflowBloc extends Bloc<WorkflowEvent, WorkflowState> {
  WorkflowBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(WorkflowState.initial()) {
    on<QualityCheckStatusUpdate>(_onQualityCheckStatusUpdate);
    
    on<GetCompletedQualityCheckTasks>(_onGetCompletedQualityCheckTasks);
    on<CycleCountStatusUpdated>(_onCycleCountStatusUpdated);
    on<SelectAllCycleCountTasks>(_onSelectAllCycleCountTasks);
    on<ButtonClicked>(_onButtonClicked);
    on<QualityCheckTasksUpdated>(_onQualityCheckTasksUpdated);
    on<CycleCountTasksUpdated>(_onCycleCountTasksUpdated);
    on<GetQualityCheckTasks>(_onGetQualityCheckTasks);
    on<GetCycleCountTasks>(_onGetCycleCountTasks);
    on<PostQualityCheckTasks>(_onPostQualityCheckTasks);
  }

  final NetworkCalls _customApi;
  final NetworkCalls _wmsCustomApi = NetworkCalls(AppConstants.WMS_URL, getIt<Dio>(),
      connectTimeout: 30, receiveTimeout: 30, maxRedirects: 5, username: 'nalsoft_adm', password: 'P@s\$w0rd2024');
  Future<void> _onGetQualityCheckTasks(GetQualityCheckTasks event, Emitter<WorkflowState> emit) async {
    try {
      emit(state.copyWith(getQualityCheckStatus: QualityCheckStatus.initial,pendingQualityCheckPageCount: event.page));
      await _customApi.get(AppConstants.QUALITYCHECK_TASKS, queryParameters: {'facility_id': '243','page_num':event.page}).then((apiResponse) {
        AreaResponse<QualityCheckTask> qualityCheckResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => QualityCheckTask.fromJson(json));

        emit(state.copyWith(qualityCheckTasks:event.page==0?qualityCheckResponse.data: [...state.qualityCheckTasks,...qualityCheckResponse.data!], getQualityCheckStatus: QualityCheckStatus.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getQualityCheckStatus: QualityCheckStatus.failure));
    }
  }

    Future<void> _onGetCompletedQualityCheckTasks(GetCompletedQualityCheckTasks event, Emitter<WorkflowState> emit) async {
    try {
      emit(state.copyWith(getQualityCheckStatus: QualityCheckStatus.initial,completedQualityCheckPageCount: event.page));
      await _customApi.get(AppConstants.QUALITYCHECK_COMPLETED_TASKS, queryParameters: {'facility_id': '243','page_num':event.page}).then((apiResponse) {
        AreaResponse<QualityCheckTask> qualityCheckResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => QualityCheckTask.fromJson(json));

        emit(state.copyWith(completedQualityChecks: event.page==0?qualityCheckResponse.data:[...state.completedQualityChecks!, ...qualityCheckResponse.data!], getQualityCheckStatus: QualityCheckStatus.success));
        print("comp length ${state.completedQualityChecks!.length}");
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getQualityCheckStatus: QualityCheckStatus.failure));
    }
  }


  void _onGetCycleCountTasks(GetCycleCountTasks event, Emitter<WorkflowState> emit) {}

  void _onQualityCheckStatusUpdate(QualityCheckStatusUpdate event, Emitter<WorkflowState> emit) {
    if (event.isChecked) {
      state.selectedQaulityCheckTasks!.addAll(event.lpnNbr);
    } else {
      for (var element in event.lpnNbr) {
        state.selectedQaulityCheckTasks!.remove(element);
      }
    }
    emit(state.copyWith(selectedQaulityCheckTasks: state.selectedQaulityCheckTasks));
  }

  void _onCycleCountStatusUpdated(CycleCountStatusUpdated event, Emitter<WorkflowState> emit) {
    state.cycleCountTasks.where((task) => task.task == event.task).first.isChecked = event.isChecked;
    emit(state.copyWith(cycleCountTasks: state.cycleCountTasks));
  }

  void _onSelectAllCycleCountTasks(SelectAllCycleCountTasks event, Emitter<WorkflowState> emit) {
    state.cycleCountTasks.forEach((task) {
      task.isChecked = event.isChecked;
    });
    emit(state.copyWith(selectedAllCycleCountTasks: event.isChecked));
  }

  void _onButtonClicked(ButtonClicked event, Emitter<WorkflowState> emit) {
    if(event.index==0){
      add(GetQualityCheckTasks(facilityID: 243,page:0));
    }
    else{
      add(GetCompletedQualityCheckTasks(page:0));
    }
    emit(state.copyWith(buttonIndex: event.index));
  }

  void _onQualityCheckTasksUpdated(QualityCheckTasksUpdated event, Emitter<WorkflowState> emit) {
    for (int i = 0; i < event.tasks.length; i++) {
      state.qualityCheckTasks.where((task) => task.lpnNbr == event.tasks[i]).first.qcStatus = event.qcStatus;
    }
    emit(state.copyWith(qualityCheckTasks: state.qualityCheckTasks));
  }

  void _onCycleCountTasksUpdated(CycleCountTasksUpdated event, Emitter<WorkflowState> emit) {
    // _customApi.post(AppConstants.POST, data: jsonEncode(event.tasks)).then((apiResponse) {
    //   emit(state.copyWith(cycleCountTasks: state.cycleCountTasks));
    // });

    for (int i = 0; i < event.tasks.length; i++) {
      state.cycleCountTasks.where((task) => task.task == event.tasks[i]).first.status = event.ccStatus;
    }
    emit(state.copyWith(cycleCountTasks: state.cycleCountTasks));
  }

  void _onPostQualityCheckTasks(PostQualityCheckTasks event, Emitter<WorkflowState> emit) async{
    try{
      emit(state.copyWith(postQualityCheckStatus: PostQualityCheckStatus.loading));
        await _wmsCustomApi.post(event.approveStatus == true ? AppConstants.QUALITYCHECK_BULK_APPROVE : AppConstants.QUALITYCHECK_BULK_REJECT,
        data:{"parameters": {"facility_id": 243, "company_id": 399, "container_nbr__in": state.selectedQaulityCheckTasks!.toList()}},
       ).then((apiResponse) {
        if (apiResponse.response!.statusCode==200){
          // if(state.selectedQaulityCheckTasks!.isNotEmpty){
          state.qualityCheckTasks.removeWhere((element) => state.selectedQaulityCheckTasks!.contains(element.lpnNbr));
          // }
          emit(state.copyWith(selectedQaulityCheckTasks: {},postQualityCheckStatus: PostQualityCheckStatus.success));  
          // add(GetQualityCheckTasks(facilityID: 243));
        }
        else{
          emit(state.copyWith(postQualityCheckStatus: PostQualityCheckStatus.failure));  
        }
    }).catchError((e){
      emit(state.copyWith(postQualityCheckStatus: PostQualityCheckStatus.failure));  
    });

    }catch(e){
      emit(state.copyWith(postQualityCheckStatus: PostQualityCheckStatus.failure));  
    }
     emit(state.copyWith(postQualityCheckStatus: PostQualityCheckStatus.initial,getQualityCheckStatus: QualityCheckStatus.initial));
  }
}
