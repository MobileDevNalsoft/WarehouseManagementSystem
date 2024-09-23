import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:warehouse_3d/pages/racks3d.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Warehouse3d extends StatefulWidget {
  const Warehouse3d({super.key});

  @override
  State<Warehouse3d> createState() => _Warehouse3dState();
}

class _Warehouse3dState extends State<Warehouse3d> {

  late Future _resources;
    late WebViewController webViewController;


 Future<List<String>> loadJS() async {
    List<String> resources = [];

    resources.add(await rootBundle.loadString('assets/index.js'));
    resources.add(await rootBundle.loadString('assets/styles.css'));
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

     final javascriptChannel = JavascriptChannel(
      'flutterChannel',
      onMessageReceived: (message) async {
        Map<String, dynamic> data = jsonDecode(message.message);

        if (data["type"] == "hotspot-create") {
          // await Future.delayed(Duration(seconds: 1));
        
        } else if (data["type"] == "hotspot-click") {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Rack3d()));
        }
        // bottom sheet for diaplying hotspots, comments and images
       
       
      },
    );
    return Scaffold(body: Container(child: FutureBuilder(
        future: _resources,
        builder: (context,snapshot) {

          if(snapshot.hasData){
          return  PointerInterceptor(
            debug: true,
            intercepting: true,
            child: ModelViewer(
               src: 'assets/glbs/wms1412.glb',
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
                                    id: 'model',
              ),
          );}
            else{
              return CircularProgressIndicator();
            }
        }
      ),));
  }
}