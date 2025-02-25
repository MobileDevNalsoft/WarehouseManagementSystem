@JS()
library js_interop;

import 'dart:convert';
import 'dart:js_util';

import 'package:js/js.dart';


@JS()
external _lpnLifeCycle(String show);

@JS()
external _isRackDataLoaded(bool value);

@JS()
external _setNumberOfTrucks(String message);


@JS()
external _sendOverviewData(String json);

@JS()
external _sendTrucksData(String json);

@JS()
external _changeFacility(String json);

@JS()
external _getShoretestPathForTask(List task);

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
  changeFacility(String data) {
    _changeFacility(data);
  }

  lpnLifeCycle(String show) {
    _lpnLifeCycle(show);
  }

  sendOverviewData(String data) {
    _sendOverviewData(data);
  }

  sendTrucksData(String data) {
    _sendTrucksData(data);
  }


  isRackDataLoaded(value) {
    _isRackDataLoaded(value);
  }

  setNumberOfTrucks(message) {
    _setNumberOfTrucks(message);
  }

  

  showAlert(String message) {
    _showAlert(message);
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
