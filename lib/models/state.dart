import 'package:flutter/cupertino.dart';

class USState {
  int id;
  String name;
  String abbreviation;

  USState({
    @required this.id,
    @required this.name,
    @required this.abbreviation,
  });

  factory USState.fromJson(Map<String, dynamic> json) {
    return USState(
      id: json['id'],
      name: json['name'],
      abbreviation: json['location'],
    );
  }

  static List<USState> fromJsonList(List<dynamic> jsonList) {
    List<USState> states = [];
    jsonList.forEach((jsonObj) {
      states.add(USState.fromJson(jsonObj));
    });
    return states;
  }
}
