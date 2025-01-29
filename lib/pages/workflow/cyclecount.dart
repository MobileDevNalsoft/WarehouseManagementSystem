import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/models/task_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class Cyclecount extends StatefulWidget {
  const Cyclecount({super.key});

  @override
  State<Cyclecount> createState() => _CyclecountState();
}

class _CyclecountState extends State<Cyclecount> {
  late final WorkflowBloc _workflowBloc;

  @override
  void initState() {
    super.initState();
    _workflowBloc = context.read<WorkflowBloc>();
    _workflowBloc.state.buttonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<WorkflowBloc, WorkflowState>(builder: (context, state) {
      return Customs.WorkflowLayout(
          size: size,
          buttonIndex: state.buttonIndex!,
          onApproved: () {
            _workflowBloc.add(CycleCountTasksUpdated(
                tasks: _workflowBloc.state.cycleCountTasks.where((e) => e.isChecked == true).map((e) => e.task!).toList(), ccStatus: 'Approved'));
            _workflowBloc.add(SelectAllCycleCountTasks(isChecked: false));
          },
          onRejected: () {
            _workflowBloc.add(CycleCountTasksUpdated(
                tasks: _workflowBloc.state.cycleCountTasks.where((e) => e.isChecked == true).map((e) => e.task!).toList(), ccStatus: 'Rejected'));
            _workflowBloc.add(SelectAllCycleCountTasks(isChecked: false));
          },
          child: Expanded(
            child: SfDataGrid(
              allowFiltering: true,
              allowSorting: true,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.auto,
              source: WorkflowCycleCountDataSource(
                data: state.buttonIndex == 0
                    ? state.cycleCountTasks.where((task) => task.status == 'Pending').toList()
                    : state.cycleCountTasks.where((task) => task.status == 'Approved' || task.status == 'Rejected').toList(),
                isCompleted: state.buttonIndex == 0 ? false : true,
                onChanged: (value, row) {
                  context.read<WorkflowBloc>().add(CycleCountStatusUpdated(task: row.getCells()[4].value, isChecked: value!));
                },
              ),
              columns: [
                if (state.buttonIndex == 0)
                  GridColumn(
                      columnName: '',
                      allowFiltering: false,
                      allowSorting: false,
                      label: Container(
                          padding: EdgeInsets.all(size.width * 0.002),
                          alignment: Alignment.center,
                          child: BlocBuilder<WorkflowBloc, WorkflowState>(
                              buildWhen: (previous, current) => previous.selectedAllCycleCountTasks != current.selectedAllCycleCountTasks,
                              builder: (context, state) {
                                return Checkbox(
                                    value: state.selectedAllCycleCountTasks,
                                    onChanged: (value) {
                                      context.read<WorkflowBloc>().add(SelectAllCycleCountTasks(isChecked: value!));
                                    });
                              }))),
                GridColumn(
                    columnName: 'Facility',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Facility',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Company ID',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Company ID',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Group Nbr',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Group Nbr',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Task',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Task',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Total Expected Qty',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Total Expected Qty',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'UOM',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'UOM',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Total Counted Qty',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Total Counted Qty',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'UOM2',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'UOM2',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Total Adjusted qty',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Total Adjusted qty',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'UOM3',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'UOM3',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Total Adjusted Cost',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Total Adjusted Cost',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Status',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Status',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Location',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Location',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Create user',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Create user',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Create Timestamp',
                    filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                    label: Container(
                        padding: EdgeInsets.all(size.width * 0.002),
                        alignment: Alignment.center,
                        child: Text(
                          'Create Timestamp',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )))
              ],
            ),
          )
          // : Center(
          //     child: Text('No Completed Tasks'),
          //   ),
          );
    });
  }
}
