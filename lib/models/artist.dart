import 'package:flutter/foundation.dart';

class Artist {
  final int id;
  final String name;
  String city;
  String state;
  String country;
  String description;

  Artist({
    @required this.id,
    @required this.name,
    this.city,
    this.state,
    this.country,
    this.description,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      description: json['description'],
    );
  }
}
