part of 'yard_bloc.dart';
enum  YardAreaStatus {initial, loading, success, failure }

final class YardState extends Equatable {
  
  YardArea? yardArea;
  YardAreaStatus yardAreaStatus;

  YardState({this.yardArea, this.yardAreaStatus=YardAreaStatus.initial});

  YardState copyWith({
    YardArea? yardArea,
    YardAreaStatus? yardAreaStatus
    }
  ) {
    return YardState( yardArea: yardArea ?? this.yardArea, yardAreaStatus:yardAreaStatus?? this.yardAreaStatus);
  }

factory YardState.initial(){
  return YardState();
}
  @override
  List<Object?> get props => [
    yardArea,
    yardAreaStatus
  ];
}
