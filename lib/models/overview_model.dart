import 'dart:convert';

class OverviewResponse {
  int? responseCode;
  String? responseMessage;
  String? data;

  OverviewResponse({this.responseCode, this.responseMessage, this.data});

  OverviewResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = jsonEncode(json['data']);
    }
  }
}