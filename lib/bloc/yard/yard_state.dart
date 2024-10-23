part of 'yard_bloc.dart';

final class YardState extends Equatable {
  YardArea? yardArea;
  String? toLocation;

  YardState({this.yardArea, this.toLocation});

  YardState copyWith({
    YardArea? yardArea,
    String? toLocation}
  ) {
    return YardState(toLocation: toLocation ?? this.toLocation, yardArea: yardArea ?? this.yardArea);
  }

factory YardState.initial(){
  return YardState();
}
  @override
  List<Object?> get props => [
    yardArea,
    toLocation
  ];
}
