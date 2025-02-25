import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/inits/web_service.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/models/container_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class LPNLifeCycleDataSheet extends StatefulWidget {
  const LPNLifeCycleDataSheet({super.key});

  @override
  State<LPNLifeCycleDataSheet> createState() => _LPNLifeCycleDataSheetState();
}

class _LPNLifeCycleDataSheetState extends State<LPNLifeCycleDataSheet> {
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  final ScrollController _controller = ScrollController();
  final List<String> prefixes = ['Created by ', 'Quality Checked by ', 'Received by ', 'Located by ', 'Allocated by ', 'Picked by ', 'Packed by ', 'Loaded by ', 'Shipped by '];

  final List<String> icons = ['created', 'quality_check', 'received', 'located', 'allocated', 'picked', 'packed', 'loaded', 'shipped'];

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _warehouseInteractionBloc.add(GetLPNLifeCycle(facilityID: 243, companyID: 2, lpnNbr: _warehouseInteractionBloc.state.dataFromJS['lpn']));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.height * 0.02),
          margin: EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.004, right: size.height * 0.01),
          height: size.height * 0.06,
          width: size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'LPN Lifecycle',
                style: TextStyle(color: Colors.white, fontSize: size.width * 0.012, letterSpacing: 1.6, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                  onTap: () async {
                    getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: 'switchToMainCam("compoundArea")');
                    getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: 'resetBinColors()');

                    context.read<WarehouseInteractionBloc>().add(SelectedObject(dataFromJS: const {"object": "null"}, clearSearchText: true));

                    getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: 'resetTrucksAnimation()');
                   getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: "lpnLifeCycle('false')");
                  },
                  child: const Icon(Icons.cancel_rounded, color: Colors.white))
            ],
          ),
        ),
        Container(
          height: size.height * 0.86,
          width: size.width * 0.3,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          padding: EdgeInsets.all(size.height * 0.012),
          child: LayoutBuilder(builder: (context, layout) {
            return BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
              builder: (context, state) {
                bool isEnabled = state.getLpnLifeCycleStatus != LPNLifeCycleStatus.success;
                return LayoutBuilder(builder: (context, lsize) {
                  String lpn = state.dataFromJS['lpn'];
                  return isEnabled
                      ? const Center(child: CircularProgressIndicator())
                      : (!isEnabled && state.lpnLifeCycle!.isEmpty)
                          ? Column(
                              children: [
                                Text(
                                  lpn != "" ? lpn : state.searchText!,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: lsize.maxWidth * 0.044, color: Colors.white),
                                ),
                                const Text(
                                  "Data not found",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  lpn,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Gap(lsize.maxHeight * 0.02),
                                Expanded(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ListView.builder(
                                    itemCount: state.lpnLifeCycle!.length,
                                    itemBuilder: (context, index) {
                                      List<LPNStatus> lpnStatuses = state.lpnLifeCycle!;
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          TimelineTile(
                                            alignment: TimelineAlign.center,
                                            isFirst: index == 0,
                                            isLast: index == state.lpnLifeCycle!.length - 1,
                                            indicatorStyle: IndicatorStyle(
                                              height: lsize.maxHeight * 0.06,
                                              width: lsize.maxHeight * 0.06,
                                              color: Colors.white,
                                            ),
                                            afterLineStyle: LineStyle(color: const Color.fromRGBO(68, 98, 136, 1)),
                                            beforeLineStyle: LineStyle(color: const Color.fromRGBO(68, 98, 136, 1)),
                                            startChild: index % 2 != 0
                                                ? Container(
                                                    margin: EdgeInsets.only(right: lsize.maxHeight * 0.015),
                                                    padding: EdgeInsets.all(lsize.maxHeight * 0.02),
                                                    decoration: BoxDecoration(
                                                        color: const Color.fromRGBO(192, 208, 230, 1),
                                                        borderRadius: BorderRadius.circular(15),
                                                        border: Border.all(color: Colors.white, width: 3)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          lpnStatuses[index].status!,
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                        ),
                                                        Text(
                                                          '${prefixes[index]}${lpnStatuses[index].user!}',
                                                          style: TextStyle(fontSize: 13),
                                                        ),
                                                        Text(
                                                          lpnStatuses[index].date!,
                                                          style: TextStyle(fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            endChild: index % 2 == 0
                                                ? Container(
                                                    margin: EdgeInsets.only(left: lsize.maxHeight * 0.015),
                                                    padding: EdgeInsets.all(lsize.maxHeight * 0.02),
                                                    decoration: BoxDecoration(
                                                        color: const Color.fromRGBO(192, 208, 230, 1),
                                                        borderRadius: BorderRadius.circular(15),
                                                        border: Border.all(color: Colors.white, width: 3)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          lpnStatuses[index].status!,
                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                        ),
                                                        Text(
                                                          '${prefixes[index]}${lpnStatuses[index].user!}',
                                                          style: TextStyle(fontSize: 13),
                                                        ),
                                                        Text(
                                                          lpnStatuses[index].date!,
                                                          style: TextStyle(fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ),
                                          Container(
                                            height: lsize.maxHeight * 0.08,
                                            width: lsize.maxWidth * 0.08,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(68, 98, 136, 1),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(lsize.maxHeight * 0.01),
                                            child: Image.asset(
                                              'assets/images/${icons[index]}.png',
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )),
                                Gap(lsize.maxHeight * 0.02)
                              ],
                            );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
