import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:warehouse_3d/js_inter.dart';

class ThreeDTest extends StatefulWidget {
  const ThreeDTest({super.key});

  @override
  State<ThreeDTest> createState() => _ThreeDTestState();
}

class _ThreeDTestState extends State<ThreeDTest> {
  
final jsIteropService = JsInteropService();
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
      body: Column(
        children: [
            ElevatedButton(
                onPressed: () {
                  jsIteropService.showAlert("Hello, world!!!!");
                },
                child: const Text("Show Alert"),
              ),
          FutureBuilder(
              future: loadWebCode(),
              builder: (context, snapshot) {
                if (true) {
                  if (true) {
                    return Container(
                      height: size.height,
                      width: size.width,
                      child: InAppWebView(
                        initialFile: 'assets/web_code/model1.html',
                        onConsoleMessage: (controller, consoleMessage) {
                          print("console message $consoleMessage");
                        },
                      ),
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
        ],
      ),
    );
  }
}
