import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/models/staging_area_model.dart';

enum StagingAreaStatus { initial, loading, success, failure }

final class StagingState {
  StagingState({this.stagingStatus, this.stagingArea, this.pageNum, this.stagingList});

  StagingAreaStatus? stagingStatus;
  StagingArea? stagingArea;
  List<StagingData>? stagingList;
  int? pageNum;

  factory StagingState.initial() {
    return StagingState(stagingStatus: StagingAreaStatus.initial, pageNum: 0, stagingList: []);
  }

  StagingState copyWith({StagingAreaStatus? stagingStatus, StagingArea? stagingArea, int? pageNum, List<StagingData>? stagingList}) {
    return StagingState(
        stagingStatus: stagingStatus ?? this.stagingStatus,
        stagingArea: stagingArea ?? this.stagingArea,
        pageNum: pageNum ?? this.pageNum,
        stagingList: stagingList ?? this.stagingList);
  }
}
