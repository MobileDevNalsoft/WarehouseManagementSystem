import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/models/warehouse_model.dart';

import 'package:webview_flutter/webview_flutter.dart';
class Rack3d extends StatefulWidget {
  const Rack3d({super.key});

  @override
  State<Rack3d> createState() => _Rack3dState();
}

class _Rack3dState extends State<Rack3d> {

 late Future _resources;
  late WebViewController webViewController;
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

 Future loadJS() async {
    List resources = [];

    resources.add(await rootBundle.loadString('assets/rack.js'));
    resources.add(await rootBundle.loadString('assets/styles.css'));
     resources.add(await WarehouseData.fromJson(jsonDecode(
        await rootBundle.loadString("assets/jsons/warehouse_data.json"))));
    return resources;
  }
 


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _resources = loadJS();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
 final javascriptChannel = JavascriptChannel(
      'flutterChannel',
      onMessageReceived: (message) async {
        Map<String, dynamic> data = jsonDecode(message.message);

        if (data["type"] == "hotspot-create") {
        //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Rack3d()));
          context.read<WarehouseInteractionBloc>().add(HotspotCreated(hotspot: data["cnt"]));
        } else if (data["type"] == "hotspot-click") {
       
        }
        // bottom sheet for diaplying hotspots, comments and images
       
       
      },
    );

    return  Scaffold(body: Container(child: FutureBuilder(
        future: _resources,
        builder: (context,snapshot) {

          if(snapshot.hasData){
          return  Column(
            children: [
              SizedBox(
                height: size.height*0.5,
                width: size.width,
                child: ModelViewer(
                   src: 'assets/glbs/rack_3d_1535.glb',
                                        backgroundColor: Colors.black38,
                                        relatedJs: snapshot.data![0],
                                        relatedCss: snapshot.data![1],
                                        disableZoom: false,
                                        autoRotate: false,
                                        disableTap: false,
                                        disablePan: false,
                                        javascriptChannels: {javascriptChannel},
                                          onWebViewCreated: (value) {
                                          webViewController = value;
                                        },
                                        id: 'rackmodel',
                  ),
              ),
              if(context.watch<WarehouseInteractionBloc>().state.hotspot!=-1)
               BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
                 builder: (context, state)  {
                   return Expanded(
                     child: Container(
                                alignment: Alignment.center,
                                // height: size.height * 0.2,
                                width: size.width,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(26, 26, 27, 1),
                                   ),
                                child: CustomScrollView(
                                  // controller: scrollController,
                                  slivers: [
                                    SliverGap(size.height*0.02),
                                    SliverToBoxAdapter(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Gap(size.width * 0.43),
                                          Text(
                                            'Rack ${snapshot.data[2]!.racks![state.index!].rackId}',
                                            // ignore: prefer_const_constructors
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 18),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          Gap(size.height * 0.02),
                                          Text(
                                            snapshot.data[2]!.racks![state.index!].categoryName!,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 18),
                                          ),
                                          Gap(size.height * 0.02),
                                          ...snapshot.data[2]!.racks![state.index!].items!.map((e) => Container(
                                            margin: EdgeInsets.symmetric(vertical: size.height*0.01),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            height: size.height*0.06,
                                            width: size.width*0.9,
                                            child: Row(
                                              children: [
                                                Gap(size.width*0.05),
                                                Text(e.itemName!),
                                                Spacer(),
                                                Text('Q ${e.quantity}'),
                                                Gap(size.width*0.05),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                   );
                 }
               )
                     
                // BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
                //   builder: (context, state) {
                //     return DraggableScrollableSheet(
                //       controller: draggableScrollableController,
                //       // Bottom sheet sizes
                //       minChildSize: 0.15,
                //       maxChildSize: 1,
                //       initialChildSize: 0.5,
                //       builder: (context, scrollController) {
                //         print("racks ${snapshot.data[2]}");
                //         return Container(
                //           alignment: Alignment.center,
                //           height: size.height * 0.2,
                //           width: size.width,
                //           decoration: const BoxDecoration(
                //               color: Color.fromRGBO(26, 26, 27, 1),
                //               borderRadius: BorderRadius.only(
                //                   topLeft: Radius.circular(24),
                //                   topRight: Radius.circular(24))),
                //           child: CustomScrollView(
                //             controller: scrollController,
                //             slivers: [
                //               SliverGap(size.height*0.02),
                //               SliverToBoxAdapter(
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Gap(size.width * 0.43),
                //                     Text(
                //                       'Rack ${snapshot.data[2]!.racks![state.index!].rackId}',
                //                       // ignore: prefer_const_constructors
                //                       style: TextStyle(
                //                           color: Colors.white, fontSize: 18),
                //                     ),
                //                     const Spacer(),
                //                   ],
                //                 ),
                //               ),
                //               SliverToBoxAdapter(
                //                 child: Column(
                //                   children: [
                //                     Gap(size.height * 0.02),
                //                     Text(
                //                       snapshot.data[2]!.racks![state.index!].categoryName!,
                //                       style: const TextStyle(
                //                           color: Colors.white, fontSize: 18),
                //                     ),
                //                     Gap(size.height * 0.02),
                //                     ...snapshot.data[2]!.racks![state.index!].items!.map((e) => Container(
                //                       margin: EdgeInsets.symmetric(vertical: size.height*0.01),
                //                       decoration: BoxDecoration(
                //                         color: Colors.white,
                //                         borderRadius: BorderRadius.circular(15)
                //                       ),
                //                       height: size.height*0.06,
                //                       width: size.width*0.9,
                //                       child: Row(
                //                         children: [
                //                           Gap(size.width*0.05),
                //                           Text(e.itemName!),
                //                           Spacer(),
                //                           Text('Q ${e.quantity}'),
                //                           Gap(size.width*0.05),
                //                         ],
                //                       ),
                //                     ))
                //                   ],
                //                 ),
                //               )
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),
             
            ],
          );}
            else{
              return CircularProgressIndicator();
            }
        }
      ),));
  }
}