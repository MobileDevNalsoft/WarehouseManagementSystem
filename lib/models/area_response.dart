class AreaResponse<T> {
  int? responseCode;
  String? responseMessage;
  List<T>? data;

  AreaResponse({this.responseCode, this.responseMessage, this.data});

  AreaResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = (json['data'] as List).map((e) => fromJsonT(e)).toList();
    }
  }
}