@JS()
library js_interop;

import 'dart:convert';
import 'dart:js_util';

import 'package:js/js.dart';

@JS()
external _switchToMainCam(String camName);

@JS()
external _isRackDataLoaded(bool value);

@JS()
external _setNumberOfTrucks(String message);

@JS()
external _resetTrucks();

@JS()
external _highlightBins(String bins);

@JS()
external _navigateToBin(String message);

@JS()
external _resetBoxColors();



@JS()
external _showAlert(String message);

@JS()
external _requestFullScreen();

@JS()
external _getData();

@JS()
external _getJsonData();

@JS()
external _getSomeAsyncData();

@JS()
external _shareImage(String url, String filename);

class JsInteropService {
  switchToMainCam(String camName) {
    _switchToMainCam(camName);
  }

  isRackDataLoaded(value) {
    _isRackDataLoaded(value);
  }

  setNumberOfTrucks(message){
    _setNumberOfTrucks(message);
  }

  resetTrucks(){
    _resetTrucks();
  }

 navigateToBin(String message) {
    _navigateToBin(message);
  }

 resetBoxColors() {
    _resetBoxColors();
  }


  showAlert(String message) {
    _showAlert(message);
  }


  highlightBins(String bins){
    _highlightBins(bins);
  }

  requestFullScreen() {
    _requestFullScreen();
  }

  getData() {
    final data = _getData();
    print(data);
  }

  getJsonData() {
    final data = _getJsonData();
    final decodedData = jsonDecode(data);
    print(decodedData['foo']);
  }

  getSomeAsyncData() async {
    final promise = await _getSomeAsyncData();
    final data = await promiseToFuture(promise);
    print(data);
  }

  shareImage(String url, String filename) async {
    final promise = await _shareImage(url, filename);
    final successResult = await promiseToFuture(promise);
    final success = successResult == "true";
    print(success);
  }
}
