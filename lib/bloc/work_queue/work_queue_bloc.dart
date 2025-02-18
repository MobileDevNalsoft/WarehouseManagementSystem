import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/local_network_calls.dart';
import 'package:wmssimulator/models/work_queue_model.dart';

part 'work_queue_event.dart';
part 'work_queue_state.dart';

class WorkQueueBloc extends Bloc<WorkQueueEvent, WorkQueueState> {
  WorkQueueBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(WorkQueueState.initial()) {
    on<GetWorkQueueData>(_onGetWorkQueueData);
  }

  NetworkCalls _customApi;

  Future<void> _onGetWorkQueueData(WorkQueueEvent event, Emitter<WorkQueueState> emit) async {
    try {
      emit(state.copyWith(workQueueStatus: WorkQueueStatus.loading));
      await _customApi.get(AppConstants.WORK_QUEUE, queryParameters: {'facility_id': '243'}).then((result) {
        if (result.response!.statusCode == 200) {
          WorkQueue data = WorkQueue.fromJson(jsonDecode(result.response!.data)["data"]);
          emit(state.copyWith(workQueueData: data, workQueueStatus: WorkQueueStatus.success));
        } else {
          emit(state.copyWith(workQueueStatus: WorkQueueStatus.failure));
        }
      });
    } catch (e) {
      emit(state.copyWith(workQueueStatus: WorkQueueStatus.failure));
    }
  }
}
