import 'package:warehouse_3d/models/inspection_area_model.dart';

class ActivityAreaItem {
  String? workOrderNum;
  String? workOrderType;
  String? item;
  int? qty;
  ActivityAreaItem({this.workOrderNum, this.workOrderType, this.item, this.qty});

  ActivityAreaItem.fromJson(Map<String, dynamic> json) {
    workOrderNum = json['work_order_num'];
    workOrderType = json['work_order_type'];
    item = json['item'];
    qty = int.parse(json['qty']);
  }
}

class ActivityDashboard{
  List<StatusCount>? todayTaskSummary;
  List<StatusCount>? taskTypeSummary;
  List<StatusCount>? todayWorkOrderSummary;
  List<StatusCount>? daywiseTaskSummary;
  List<StatusCount>? empwiseTaskSummary;
  List<StatusCount>? avgTimeTakenByEmp;
  String? avgTaskExecTime;
  String? avgPickTime;
  ActivityDashboard({this.todayTaskSummary, this.taskTypeSummary, this.todayWorkOrderSummary, this.daywiseTaskSummary, this.empwiseTaskSummary, this.avgTaskExecTime, this.avgPickTime, this.avgTimeTakenByEmp});

  ActivityDashboard.fromJson(Map<String, dynamic> json){
    todayTaskSummary = (json['today_task_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    taskTypeSummary = (json['task_type_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    todayWorkOrderSummary = (json['today_work_order_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    daywiseTaskSummary = (json['daywise_task_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    empwiseTaskSummary = (json['empwise_task_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    avgTimeTakenByEmp = (json['avg_time_taken_by_emp'] as List).map((e) => StatusCount.fromJson(e)).toList();
    avgTaskExecTime = json['avg_task_exec_time'];
    avgPickTime = json['avg_pick_time'];
  }
}
