import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/js_inter.dart';
import 'package:warehouse_3d/main.dart';

class ThreeDTest extends StatefulWidget {
  const ThreeDTest({super.key});

  @override
  State<ThreeDTest> createState() => _ThreeDTestState();
}

class _ThreeDTestState extends State<ThreeDTest> {
  final jsIteropService = JsInteropService();
  late Map<dynamic, dynamic> _json;

  @override
  void initState() {
    super.initState();

    context.read<WarehouseInteractionBloc>().add(SelectedObject(object: "box-123"));
  }

  Future loadJson() async {
    return jsonDecode(await DefaultAssetBundle.of(context).loadString("jsons/warehouse_data.json"));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          // color: Colors.black,
          child: Row(
        children: [
          Expanded(
            child: InAppWebView(
                initialFile: 'assets/web_code/model1.html',
                onConsoleMessage: (controller, consoleMessage) {
                  try {
                    print("meessage level ${consoleMessage.messageLevel}");
                    var obj = jsonDecode(consoleMessage.message);
                    print("obj $obj");
                    context.read<WarehouseInteractionBloc>().add(SelectedObject(object: obj["object"]));
                  } catch (e) {
                    print("error $e   ");
                  }
                }),
          ),
          if (context.watch<WarehouseInteractionBloc>().state.object != null)
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.78, top: size.height * 0.05, bottom: size.height * 0.05, right: size.width * 0.002),
            child: FutureBuilder(
                future: loadJson(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("data ${snapshot.data}");
                    if (context.watch<WarehouseInteractionBloc>().state.object != null) {
                      Map data = (snapshot.data["warehouse"]["boxes"] as List).firstWhere(
                        (e) => e["boxId"] == context.watch<WarehouseInteractionBloc>().state.object,
                        orElse: () {
                          return snapshot.data["warehouse"]["boxes"][1];
                        },
                      );
                      print("first obj ${snapshot.data["warehouse"]["boxes"][0]["boxId"]}");
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            // color: Colors.black45,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [BoxShadow(color: Colors.white, blurRadius: 5, spreadRadius: 5)]),
                        width: size.width * (0.2),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(),
                                Text(
                                  data["boxId"].toString().toUpperCase(),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                                ),
                                // IconButton(
                                //     onPressed: () {
                                //       context.read<WarehouseInteractionBloc>().add(SelectedObject(object: null));
                                //     },
                                //     icon: Icon(
                                //       Icons.cancel_rounded,
                                //       // color: Colors.white,
                                //     ))
                              ],
                            ),
                             Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text("Category",style: TextStyle(fontSize: 18),),
                                  Text(
                                    data["category"],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),

                            Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Capacity",
                                        style: TextStyle(fontSize: 16, color: Colors.black54),
                                      ),
                                      Text("24", style: TextStyle(fontSize: 20))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    child: Column(
                                  children: [Text("Quantity",style: TextStyle(fontSize: 16, color: Colors.black54),), Text("24", style: TextStyle(fontSize: 20))],
                                ))
                              ],
                            ),
                            Gap(8),
                           
                            // Gap(16),
                            // Align(alignment: Alignment.centerLeft,child: Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text("Capacity",style: TextStyle(fontSize: 18),),
                            // )),
                            Gap(16),
                            Container(
                              
                              decoration: BoxDecoration(
                                  // color: Colors.black12
                                  ),
                              child: Column(
                                children: [
                                  Text(
                                    "Items",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: size.height*0.4,
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                        children: (data["items"] as List)
                                            .map((element) => SizedBox(
                                                height: size.height * 0.064,
                                                child: Card(
                                                    child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      child: Text(element["itemName"].toString()),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                                      child: Text(element["quantity"].toString()),
                                                    )
                                                  ],
                                                ))))
                                            .toList()),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        // ElevatedButton(
                        //   child:
                        //   onPressed: () {
                        //     print(context.read<WarehouseInteractionBloc>().state.object.toString());
                        //     jsIteropService.showAlert(context.read<WarehouseInteractionBloc>().state.object.toString());
                        //   },
                        // )
                      );
                    } else {
                      return SizedBox();
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          )
        ],
      )),
    );
  }
}
