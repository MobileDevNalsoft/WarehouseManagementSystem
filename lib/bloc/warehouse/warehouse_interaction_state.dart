part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }

enum GetStagingAreaDataState { initial, loading, success, failure }

enum GetActivityAreaDataState { initial, loading, success, failure }

enum GetReceivingAreaDataState { initial, loading, success, failure }

enum GetInspectionAreaDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class WarehouseInteractionState{
  WarehouseInteractionState({required this.dataFromJS, this.inAppWebViewController, this.isModelLoaded = false, this.selectedSearchArea = "Storage", this.searchText});

  Map<String, dynamic> dataFromJS;
  InAppWebViewController? inAppWebViewController;
  bool isModelLoaded;
  String selectedSearchArea;
  String? searchText;
  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(dataFromJS: {"object": "null"}, isModelLoaded: false);
  }

  WarehouseInteractionState copyWith({Map<String, dynamic>? dataFromJS, bool? isModelLoaded, String? selectedSearchArea, String? searchText}) {
    return WarehouseInteractionState(
        dataFromJS: dataFromJS ?? this.dataFromJS,
        isModelLoaded: isModelLoaded ?? this.isModelLoaded,
        inAppWebViewController: inAppWebViewController,
        selectedSearchArea: selectedSearchArea ?? this.selectedSearchArea,
        searchText: searchText ?? this.searchText);
  }

  @override
  List<Object?> get props => [
        dataFromJS,
        inAppWebViewController,
        isModelLoaded,
        selectedSearchArea,
        searchText,
      ];
}
