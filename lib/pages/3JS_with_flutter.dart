import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/main.dart';

import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/bin_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/inspection_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/rack_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/receiving_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/staging_area_data_sheet.dart';

import '../js_inter.dart';
import '../models/rack_model.dart';

class ThreeDTest extends StatefulWidget {
  const ThreeDTest({super.key});

  @override
  State<ThreeDTest> createState() => _ThreeDTestState();
}

class _ThreeDTestState extends State<ThreeDTest> {
  final jsIteropService = JsInteropService();
  late InAppWebViewController webViewController;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  WebMessageChannel? webMessageChannel;
  WebMessagePort? port1;
  WebMessagePort? port2;

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: context
                          .watch<WarehouseInteractionBloc>()
                          .state
                          .dataFromJS!
                          .keys
                          .first !=
                      'object'
                  ? size.width * 0.78
                  : size.width,
              child: InAppWebView(
                initialFile: 'assets/web_code/model1.html',
                onConsoleMessage: (controller, consoleMessage) {
                  try {
                    if (consoleMessage.messageLevel.toNativeValue() == 1) {
                      print('console message ${consoleMessage.message}');
                      Map<String, dynamic> message =
                          jsonDecode(consoleMessage.message);
                      _warehouseInteractionBloc
                          .add(SelectedObject(dataFromJS: message));
                    }
                  } catch (e) {
                    print("error $e");
                  }
                },
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) async {},
              ),
            ),
          ),
          if (context
                  .watch<WarehouseInteractionBloc>()
                  .state
                  .dataFromJS!
                  .keys
                  .first !=
              'object')
            Align(
              alignment: Alignment.centerRight,
              child: getDataSheetFor(
                      _warehouseInteractionBloc.state.dataFromJS!.keys.first,
                      _warehouseInteractionBloc.state.dataFromJS!.values.first.toString()
                          ) ??
                  SizedBox(),
            ),
          
        ],
      ),
    );
  }

  Widget? getDataSheetFor(String objectName, String objectValue) {
    switch(objectName){
      case 'rack':
        return RackDataSheet();
      case 'bin':
        return BinDataSheet();
      case 'area':
        switch(objectValue){
          case 'stagingArea':
            return StagingAreaDataSheet();
          case 'activityArea':
            return ActivityAreaDataSheet();
          case 'receivingArea':
            return ReceivingAreaDataSheet();
          case 'inspectionArea':
            return InspectionAreaDataSheet();
        }
    }
  }
}
