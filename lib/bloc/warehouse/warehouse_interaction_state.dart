part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }

enum GetStagingAreaDataState { initial, loading, success, failure }

enum GetActivityAreaDataState { initial, loading, success, failure }

enum GetReceivingAreaDataState { initial, loading, success, failure }

enum GetInspectionAreaDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class WarehouseInteractionState extends Equatable {
  WarehouseInteractionState(
      {this.dataFromJS,
      this.inAppWebViewController,
      this.isModelLoaded=false});

  Map<String, dynamic>? dataFromJS;
  InAppWebViewController? inAppWebViewController;
  bool isModelLoaded;
  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(
        dataFromJS: const {"object": "null"},
        isModelLoaded: false
        );
  }

  WarehouseInteractionState copyWith({
    Map<String, dynamic>? dataFromJS,
    bool? isModelLoaded
  }) {
    return WarehouseInteractionState(
      dataFromJS: dataFromJS ?? this.dataFromJS,
      isModelLoaded: isModelLoaded??this.isModelLoaded
    );
  }

  @override
  List<Object?> get props => [
        dataFromJS,
        isModelLoaded
      ];
}
