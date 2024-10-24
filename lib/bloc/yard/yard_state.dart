part of 'yard_bloc.dart';
enum  YardAreaStatus {initial, loading, success, failure }

final class YardState extends Equatable {
  
  YardArea? yardArea;
  String? toLocation;
  YardAreaStatus yardAreaStatus;

  YardState({this.yardArea, this.toLocation, this.yardAreaStatus=YardAreaStatus.initial});

  YardState copyWith({
    YardArea? yardArea,
    String? toLocation,
    YardAreaStatus? yardAreaStatus
    }
  ) {
    return YardState(toLocation: toLocation ?? this.toLocation, yardArea: yardArea ?? this.yardArea,yardAreaStatus:yardAreaStatus?? this.yardAreaStatus);
  }

factory YardState.initial(){
  return YardState();
}
  @override
  List<Object?> get props => [
    yardArea,
    toLocation,
    yardAreaStatus
  ];
}
