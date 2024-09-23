import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class Warehouse3d extends StatefulWidget {
  const Warehouse3d({super.key});

  @override
  State<Warehouse3d> createState() => _Warehouse3dState();
}

class _Warehouse3dState extends State<Warehouse3d> {
  late Future _resources;
  Future<List<String>> loadJS() async {
    List<String> resources = [];
    resources.add(await rootBundle.loadString('index.html'));
    resources.add(await rootBundle.loadString('assets/index.js'));
    return resources;
  }
  late WebViewXController _controler;

  @override
  void initState() {
    super.initState();
    _resources = loadJS();
 
    //  _controler = WebViewControllerPlus()
    //   ..loadFlutterAssetServer('assets/index.html')
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
       //   ..setBackgroundColor(const Color(0x00000000))
    //   ..
      
  }

  @override
  Widget build(BuildContext context) {
    // final javascriptChannel = JavascriptChannel(
    //   'flutterChannel',
    //   onMessageReceived: (message) async {
    //     print("message received");
    //     Map<String, dynamic> data = jsonDecode(message.message);

    //     if (data["type"] == "hotspot-create") {
    //     } else if (data["type"] == "hotspot-click") {
          
    //     }
   
    //   },
    // );

      Size size = MediaQuery.sizeOf(context);
      print(size.height);
      print(size.width);
    return Scaffold(
      body: Container(
        child:
         FutureBuilder(
          future: _resources,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  Center(
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: WebViewX(
                      
                      initialContent: snapshot.data[0],
                      initialSourceType: SourceType.html,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated:  (controller) {_controler = controller;
                      Future.delayed(Duration(seconds: 5),() {
                        
                         _controler.callJsMethod("test1", ["abc","def"]);
                      },);
                      },
                      width: size.width,
                      height: size.height,
                      jsContent: {EmbeddedJsContent(js:snapshot.data[1])},
                      dartCallBacks: { 
                      DartCallback(name: "flutterChannel", callBack:(message) {
                         Map<String, dynamic> data = jsonDecode(message);
                        print(data);
                      },)
                      },
                      
                  ),
                ),
              );
              // ModelViewer(
              //   src: 'assets/glbs/wms1412.glb',
              //   interactionPrompt: InteractionPrompt.none,
              //   relatedJs: snapshot.data![0],
              //   // relatedCss: snapshot.data![1],
              //   disableZoom: false,
              //   autoRotate: false,
              //   disableTap: false,
              //   // touchAction: Touch,
              //   id: 'model',
              //   onWebViewCreated: (value) {
              //     // value.platform.
              //     // webViewController = value;
              //   },
              //   // javascriptChannels: {javascriptChannel},
              // );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
