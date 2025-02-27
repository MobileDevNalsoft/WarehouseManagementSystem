import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wmssimulator/bloc/trips/trips_bloc.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/models/task_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class TripsTrack extends StatefulWidget {
  const TripsTrack({super.key});

  @override
  State<TripsTrack> createState() => _TripsTrackState();
}

class _TripsTrackState extends State<TripsTrack> {
  late final TripsBloc _tripsBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<TripsBloc, TripsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            children: [
              // Container(
              //     height: size.height * 0.07,
              //     width: size.width * 0.18,
              //     alignment: Alignment.center,
              //     decoration: const BoxDecoration(color: Color.fromRGBO(68, 98, 136, 1), borderRadius: BorderRadius.all(Radius.circular(50))),
              //     padding: EdgeInsets.all(size.height * 0.01),
              //     child: Text('Trips')),
              // Gap(size.height * 0.02),
              Expanded(
                child: Container(
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Skeletonizer(
                          enabled: state.getTripsStatus == TripsStatus.loading,
                          child: Stack(
                            children: [
                              SfDataGrid(
                                allowFiltering: true,
                                allowSorting: true,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility: GridLinesVisibility.both,
                                columnWidthMode: ColumnWidthMode.auto,
                                source: TripsDataSource(
                                  data: state.trips!,
                                ),
                                columns: [
                                  GridColumn(
                                      columnName: 'Shipment Nbr',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Shipment Nbr',
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
                                      columnName: 'Vehicle Nbr',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Vehicle Nbr',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Driver',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Driver',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Start Location',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Start Location',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Start Latitude',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Latitude',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Start Longitude',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Longitude',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'End Location',
                                      allowFiltering: false,
                                      allowSorting: false,
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'End Location',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'End Latitude',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Latitude',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'End Longitude',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Longitude',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Carrier',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Carrier',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Trailer Type',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Trailer Type',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Estimated Start Date',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Estimated Start Date',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ))),
                                  GridColumn(
                                      columnName: 'Estimated Delivery Date',
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Estimated Delivery Date',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          )))
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    )),
              ),
            ],
          );
        });
  }
}
