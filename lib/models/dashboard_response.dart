class DashboardResponse<T> {
  int? responseCode;
  String? responseMessage;
  T? data;

  DashboardResponse({this.responseCode, this.responseMessage, this.data});

  DashboardResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = fromJsonT(json['data']);
    }
  }
}