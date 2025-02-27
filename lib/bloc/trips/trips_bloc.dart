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
import 'package:wmssimulator/models/trip_model.dart';

import '../../models/area_response.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(TripsState.initial()) {
    on<GetTrips>(_onGetTrips);
  }

  final NetworkCalls _customApi;
  Future<void> _onGetTrips(GetTrips event, Emitter<TripsState> emit) async {
    try {
      emit(state.copyWith(getTripsStatus: TripsStatus.loading));
      Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(getTripsStatus: TripsStatus.success));
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getTripsStatus: TripsStatus.failure));
    }
  }
}
