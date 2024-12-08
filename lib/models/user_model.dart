import 'dart:convert';

class User {
  String? username;
  List<String>? access;
  User({this.username, this.access});

  User.fromJson(Map<String, dynamic> json) {
    username = json.keys.first;
    access = (jsonDecode(json.values.first) as List).map((e) => e as String).toList();
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {};
    data['username'] = username;
    data['access'] = access.toString();
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