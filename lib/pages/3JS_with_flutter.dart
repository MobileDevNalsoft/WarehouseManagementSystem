import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ThreeDTest extends StatefulWidget {
  const ThreeDTest({super.key});

  @override
  State<ThreeDTest> createState() => _ThreeDTestState();
}

class _ThreeDTestState extends State<ThreeDTest> {
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
      body: FutureBuilder(
          future: loadWebCode(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Container(
                  height: size.height,
                  width: size.width,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.parse('assets/web_code/model1.html'))
                    ),
                    initialSettings: InAppWebViewSettings(
                      
                    ),
                    onWebViewCreated: (controller) {
                      print('created');
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
    );
  }
}
