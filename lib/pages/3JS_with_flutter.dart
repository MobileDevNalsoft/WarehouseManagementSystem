import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ThreeDTest extends StatefulWidget {
  const ThreeDTest({super.key});

  @override
  State<ThreeDTest> createState() => _ThreeDTestState();
}

class _ThreeDTestState extends State<ThreeDTest> {
late InAppWebViewController inAppWebViewController ;
late WebViewXController _controller;
  Future<String> loadWebCode() async {
    return await rootBundle.loadString('assets/web_code/model1.html');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(actions: [ElevatedButton(onPressed: (){
        inAppWebViewController.evaluateJavascript(source: """window.flutter_inappwebview.callHandler('test', 'data from Flutter');""");
      //  JsInteropService().showAlert("helloooo");
      }, child: Text("Appbar"))],),
      body: FutureBuilder(
          future: loadWebCode(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Container(
                  height: size.height,
                  width: size.width,
                  child:
                  
//                   InAppWebView(
//                     initialUrlRequest: URLRequest(
//                       url: WebUri.uri(Uri.parse('assets/web_code/model1.html'))
//                     ),
//                     onConsoleMessage: (controller, consoleMessage) {
//                       inAppWebViewController = controller;
//                       print("onconsole");
//                       print("from dart $consoleMessage");
//                     },
//                     onWebViewCreated: (controller) {
//                       print('created');
//                       Future.delayed(Duration(seconds: 5),(){

//                       JsInteropService().showAlert("helloooo");
//                       });
//                       // print("web id ${controller.platform.id}");
//                       // controller.callAsyncJavaScript(functionBody: "test()" );
//                       // controller.evaluateJavascript(source: """window.flutter_inappwebview.callHandler('test', 'data from Flutter');""");
//                       // controller.addJavaScriptHandler(handlerName: "test", callback: (arguments) {
//                       //   print("handled channel");
//                       //   print(arguments);
//                       // },);
//   //                     ch!.id;
//   //                     controller.evaluateJavascript(source:"""window.flutter_inappwebview.callHandler('test', 'data from Flutter');
//   // """);
//                       // controller.addJavaScriptHandler(handlerName: "test", callback: (arguments) {
                        
//                       // },);
//                     },
//                     onLoadStop: (controller, url) async {
//                       print("load end");
//   await controller.evaluateJavascript(source: """
//     window.flutter_inappwebview.callHandler('showJsAlert()');
//   """);
// }
//                     // onLoadStop: (controller, url) async {
//                     //   if (!Platform.isAndroid) {
//                     //     // wait until the page is loaded, and then create the Web Message Channel
//                     //     var webMessageChannel = await controller.createWebMessageChannel();
//                     //     var port1 = webMessageChannel!.port1;
//                     //     var port2 = webMessageChannel.port2;
  
//                     //     // set the web message callback for the port1
//                     //     await port1.setWebMessageCallback((message) async {
//                     //       print("Message coming from the JavaScript side: $message");
//                     //       // when it receives a message from the JavaScript side, respond back with another message.
//                     //       await port1.postMessage(WebMessage(data: "${message!} and back"));
//                     //     });
  
//                     //     // transfer port2 to the webpage to initialize the communication
//                     //     await controller.postWebMessage(message: WebMessage(data: "capturePort", ports: [port2]), targetOrigin: WebUri.uri(Uri.parse("*")));
//                     //   }
//                     // },
//                   ),
                
                );
              } else {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
