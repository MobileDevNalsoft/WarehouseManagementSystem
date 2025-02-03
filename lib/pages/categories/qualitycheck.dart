import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/models/task_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class QualityCheck extends StatefulWidget {
  const QualityCheck({super.key});

  @override
  State<QualityCheck> createState() => _QualityCheckState();
}

class _QualityCheckState extends State<QualityCheck> {
  late final WorkflowBloc _workflowBloc;

  @override
  void initState() {
    super.initState();
    _workflowBloc = context.read<WorkflowBloc>();
    _workflowBloc.add(GetQualityCheckTasks(facilityID: 243,page: 0));
    _workflowBloc.state.buttonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<WorkflowBloc, WorkflowState>(
        buildWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.postQualityCheckStatus == PostQualityCheckStatus.success) {
            Customs.AnimatedDialog(
              context: context,
              header: const Icon(
                Icons.check_circle,
                size: 30,
              ),
              content: const [
                Text(
                  'Successfully Updated',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )
              ],
            );
          } else if (state.postQualityCheckStatus == PostQualityCheckStatus.failure) {
            Customs.AnimatedDialog(
              context: context,
              header: const Icon(
                Icons.error_outline_rounded,
                size: 30,
              ),
              content: const [
                Text(
                  'Failed to updtate',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )
              ],
            );
          }
        },
        builder: (context, state) {
          return Customs.WorkflowLayout(
              size: size,
              buttonIndex: _workflowBloc.state.buttonIndex!,
              onApproved: () {
                if (state.selectedQaulityCheckTasks!.isEmpty) {
                  Customs.AnimatedDialog(
                    context: context,
                    header: const Icon(
                      Icons.warning_amber_rounded,
                      size: 30,
                    ),
                    content: const [
                      Text(
                        'Please select atleast one task',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  );
                  return;
                }
                _workflowBloc.add(PostQualityCheckTasks(approveStatus: true));
                // _workflowBloc.add(QualityCheckTasksUpdated(
                //     tasks: _workflowBloc.state.qualityCheckTasks
                //         .where((e) => e.isChecked == true)
                //         .map(
                //           (e) => e.lpnNbr!,
                //         ).toList(),
                //     qcStatus: 'QC Approved'));
                // _workflowBloc.add(SelectAllQualityCheckTasks(isChecked: false));
              },
              onRejected: () {
                // if(state.selectedQaulityCheckTasks!.isEmpty){
                //   Customs.AnimatedDialog(
                //     context: context,
                //     header: const Icon(
                //       Icons.warning_amber_rounded,
                //       size: 30,
                //     ),
                //     content: const [
                //       Text(
                //         'Please select atleast one task',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(fontSize: 18),
                //       )
                //     ],
                //   );
                //   return;
                // }
                _workflowBloc.add(PostQualityCheckTasks(approveStatus: false));
                // _workflowBloc.add(
                //     QualityCheckTasksUpdated(tasks: _workflowBloc.state.qualityCheckTasks.where((e) => e.isChecked == true).map((e) => e.lpnNbr!).toList(), qcStatus: 'QC Rejected'));
                // _workflowBloc.add(SelectAllQualityCheckTasks(isChecked: false));
              },
              child: Expanded(
                  child: Skeletonizer(
                enabled: state.getQualityCheckStatus == QualityCheckStatus.loading,
                child: Stack(
                  children: [
                    SfDataGrid(
                      loadMoreViewBuilder: (context, loadMoreRows) {
                        // if () {
                          if(state.getQualityCheckStatus!=QualityCheckStatus.loading)
                          {
                            if(state.buttonIndex == 0){
                              _workflowBloc.add(GetQualityCheckTasks(facilityID: 243,page: state.pendingQualityCheckPageCount!=null?state.pendingQualityCheckPageCount!+1:0));
                            }
                            else{
                              _workflowBloc.add(GetCompletedQualityCheckTasks(page: state.completedQualityCheckPageCount!=null?state.completedQualityCheckPageCount!+1:0));
                            }
                           
                          }
                           return Container(
                              height: 60,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          
                        // } else {
                        //   if (state.completedQualityCheckPageCount != null) {
                        //     state.completedQualityCheckPageCount = state.completedQualityCheckPageCount! + 1;
                        //     _workflowBloc.add(GetCompletedQualityCheckTasks(page: state.completedQualityCheckPageCount!));
                        //   }
                        // }
                      },
                      allowFiltering: true,
                      allowSorting: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      columnWidthMode: ColumnWidthMode.auto,
                      source: WorkflowQualityCheckDataSource(
                        data: state.buttonIndex == 0 ? state.qualityCheckTasks.toList() : state.completedQualityChecks!.toList(),
                        // : state.qualityCheckTasks.where((task) => task.qcStatus == 'QC Approved' || task.qcStatus == 'QC Rejected').toList(),
                        isCompleted: state.buttonIndex == 0 ? false : true,
                        onChanged: (value, row) {
                          context.read<WorkflowBloc>().add(QualityCheckStatusUpdated(lpnNbr: [row.getCells()[2].value], isChecked: value!));
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
                                      // buildWhen: (previous, current) => previous.selectedAllQualityCheckTasks != current.selectedAllQualityCheckTasks,
                                      builder: (context, state) {
                                    return Checkbox(
                                        value: state.selectedQaulityCheckTasks!.isNotEmpty && state.qualityCheckTasks.length == state.selectedQaulityCheckTasks!.length,
                                        onChanged: (value) {
                                          context
                                              .read<WorkflowBloc>()
                                              .add(QualityCheckStatusUpdated(lpnNbr: state.qualityCheckTasks.map((e) => e.lpnNbr!).toList(), isChecked: value!));
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
                            columnName: 'LPN Nbr',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'LPN Nbr',
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
                            columnName: 'QC Status',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'QC Status',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Item Code',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Item Code',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Item Description',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Item Description',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Curr Qty',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Curr Qty',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'UOM',
                            allowFiltering: false,
                            allowSorting: false,
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'UOM',
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
                            columnName: 'Batch Nbr',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Batch Nbr',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Expiry Date',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Expiry Date',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Manufacture Date',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Manufacture Date',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Orig Qty',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Orig Qty',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        // GridColumn(
                        //     columnName: 'UOM2',
                        //     allowFiltering: false,
                        //     allowSorting: false,
                        //     label: Container(
                        //         padding: EdgeInsets.all(size.width * 0.002),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           'UOM2',
                        //           style: const TextStyle(fontWeight: FontWeight.bold),
                        //         ))),
                        GridColumn(
                            columnName: 'Received Qty',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Received Qty',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        // GridColumn(
                        //     columnName: 'UOM3',
                        //     allowFiltering: false,
                        //     allowSorting: false,
                        //     label: Container(
                        //         padding: EdgeInsets.all(size.width * 0.002),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           'UOM3',
                        //           style: const TextStyle(fontWeight: FontWeight.bold),
                        //         ))),
                        GridColumn(
                            columnName: 'PO Nbr',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'PO Nbr',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Received Shipment',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Received Shipment',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Putaway Type',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Putaway Type',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Receiving User',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Receiving User',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Shipment Type',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Shipment Type',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: 'Weight',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Weight',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        // GridColumn(
                        //     columnName: 'uom_wt',
                        //     allowFiltering: false,
                        //     allowSorting: false,
                        //     label: Container(
                        //         padding: EdgeInsets.all(size.width * 0.002),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           'uom_wt',
                        //           style: const TextStyle(fontWeight: FontWeight.bold),
                        //         ))),

                        GridColumn(
                            columnName: 'Volume',
                            filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  'Volume',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        // GridColumn(
                        //     columnName: 'uom_vol',
                        //     allowFiltering: false,
                        //     allowSorting: false,
                        //     label: Container(
                        //         padding: EdgeInsets.all(size.width * 0.002),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           'uom_vol',
                        //           style: const TextStyle(fontWeight: FontWeight.bold),
                        //         ))),
                        GridColumn(
                            columnName: (state.buttonIndex == 0) ? 'Submitted by' : 'Updated by',
                            allowFiltering: false,
                            allowSorting: false,
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  (state.buttonIndex == 0) ? 'Submitted by' : 'Updated by',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        GridColumn(
                            columnName: (state.buttonIndex == 0) ? 'Submitted timestamp' : 'Updated timestamp',
                            allowFiltering: false,
                            allowSorting: false,
                            label: Container(
                                padding: EdgeInsets.all(size.width * 0.002),
                                alignment: Alignment.center,
                                child: Text(
                                  (state.buttonIndex == 0) ? 'Submitted timestamp' : 'Updated timestamp',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                    if (state.postQualityCheckStatus == PostQualityCheckStatus.loading)
                      Center(
                        child: Container(child: Customs.DashboardLoader(lsize: BoxConstraints(maxWidth: size.width * 0.5, maxHeight: size.height * 0.5))),
                      )
                  ],
                ),
              ))
              // : Center(
              //     child: Text('No Pending Tasks'),
              //   )
              );
        });
  }
}
