import 'dart:convert';

class User {
  String? username;
  List<String>? access;
  User({this.username, this.access});
  User.fromJson(Map<String, dynamic> json) {
    username = json.keys.first;
    access = (jsonDecode(json.values.first) as List).map((e) => e as String).toList();
  }
}