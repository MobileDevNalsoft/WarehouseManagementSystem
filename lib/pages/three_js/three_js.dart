import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/bin_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/inspection_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/rack_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/receiving_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/staging_area_data_sheet.dart';
import '../../js_interop_service/js_inter.dart';

class ThreeJsWebView extends StatefulWidget {
  const ThreeJsWebView({super.key});

  @override
  State<ThreeJsWebView> createState() => _ThreeJsWebViewState();
}

class _ThreeJsWebViewState extends State<ThreeJsWebView> with TickerProviderStateMixin {
  final jsIteropService = JsInteropService();
  late InAppWebViewController webViewController;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  // for animation
  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<double> positionAnimation;

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();

    animationController = AnimationController(duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 100), vsync: this);
    widthAnimation = Tween<double>(begin: 1, end: 0.82).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    positionAnimation = Tween<double>(begin: -350, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));

    // Listen for changes in the state
    _warehouseInteractionBloc.stream.listen((state) {
      if (state.dataFromJS!.keys.first != 'object') {
        animationController.forward(); // Start animation when data sheet is visible
      } else{
        animationController.reverse(); // Reverse when not visible
      }
    });
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
            child: AnimatedBuilder(
              animation: widthAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: size.width*widthAnimation.value,
                  child: InAppWebView(
                    initialFile: 'assets/web_code/model.html',
                    onConsoleMessage: (controller, consoleMessage) {
                      try {
                        if (consoleMessage.messageLevel.toNativeValue() == 1) {
                          print('console message ${consoleMessage.message}');
                          Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                          _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message));
                        }
                      } catch (e) {
                        print("error $e");
                      }
                    },
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                    },
                    onLoadStop: (controller, url) async {},
                  ),
                );
              }
            ),
          ),
          AnimatedBuilder(
            animation: positionAnimation,
            builder: (context, child) {
              return Positioned(
                right: positionAnimation.value,
                child: 
                getDataSheetFor(
                        context.watch<WarehouseInteractionBloc>().state.dataFromJS!.keys.first, context.watch<WarehouseInteractionBloc>().state.dataFromJS!.values.first.toString()) ??
                    const SizedBox(),
              );
            }
          )
        ],
      ),
    );
  }

  Widget? getDataSheetFor(String objectName, String objectValue) {
    switch (objectName) {
      case 'rack':
        return const RackDataSheet();
      case 'bin':
        return const BinDataSheet();
      case 'area':
        switch (objectValue) {
          case 'stagingArea':
            return const StagingAreaDataSheet();
          case 'activityArea':
            return const ActivityAreaDataSheet();
          case 'receivingArea':
            return const ReceivingAreaDataSheet();
          case 'inspectionArea':
            return const InspectionAreaDataSheet();
        }
    }
  }
}
