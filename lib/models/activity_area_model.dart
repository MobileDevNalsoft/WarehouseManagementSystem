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
  ActivityDashboard({this.todayTaskSummary});

  ActivityDashboard.fromJson(Map<String, dynamic> json){
    todayTaskSummary = (json['today_task_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
  }
}
