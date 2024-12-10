import 'dart:convert';

class User {
  String? username;
  List<String>? access;
  User({this.username, this.access});

  User.fromJson(Map<String, dynamic> json) {
    username = json.keys.first;
    access = (json.values.first as String).split(',');
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {};
    data['username'] = username;
    data['access'] = access!.join(',');
    return data;
  }

  User copy() {
    return User(username: username, access: access);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.username == username && other.access == access;
  }

  @override
  int get hashCode => username.hashCode ^ access.hashCode; // Combine hash codes
}

class Alert{
  String? subject;
  String? body;
  String? time;
  Alert({this.subject, this.body, this.time});

  Alert.fromJson(Map<String, dynamic> json){
    subject = json['subject'];
    body = json['body'];
    time = json['time'];
  }
}