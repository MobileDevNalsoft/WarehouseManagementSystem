
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  JsInteropService? jsInteropService;
  ActivityBloc({this.jsInteropService}) : super(ActivityState.initial()) {
  }


}
