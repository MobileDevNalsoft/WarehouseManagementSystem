import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebService {
  InAppWebViewController? inAppWebViewController;

  void setController(InAppWebViewController controller) {
    inAppWebViewController = controller;
  }
}