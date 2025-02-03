import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/local_network_calls.dart';
import 'package:wmssimulator/logger/logger.dart';
import 'package:wmssimulator/models/container_model.dart';

part 'container_event.dart';
part 'container_state.dart';

class ContainerBloc extends Bloc<ContainerEvent, ContainerState> {
  ContainerBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(ContainerState.initial()) {
    on<GetContainers>(_onGetConatainers);
    on<OnHover>(_onOnHover);
  }

  final NetworkCalls _customApi;

  Future<void> _onGetConatainers(GetContainers event, Emitter<ContainerState> emit) async {
    try {
      emit(state.copyWith(getContainerStatus: ContainerStatus.loading));
      // await _customApi.get(AppConstants.CONTAINERS).then((apiResponse) {
      // AreaResponse<ContainerData> containerResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => ContainerData.fromJson(json));
      emit(state.copyWith(containers: state.containers, getContainerStatus: ContainerStatus.success));
      // });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getContainerStatus: ContainerStatus.failure));
    }
  }

  void _onOnHover(OnHover event, Emitter<ContainerState> emit) {
    emit(state.copyWith(isHovering: event.isHovering, hoveredContainer: event.hoveredContainer));
  }
}
