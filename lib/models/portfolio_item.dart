import 'package:flutter/foundation.dart';

import 'package:lloud_mobile/models/song.dart';

class PortfolioItem {
  final int id;
  final int points_earned;
  final Song song;

  const PortfolioItem({
    @required this.id,
    @required this.points_earned,
    @required this.song,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
        id: json['id'],
        points_earned: json['points_earned'],
        song: Song.fromJson(json["song"]));
  }

  static List<PortfolioItem> fromJsonList(List<dynamic> jsonList) {
    List<PortfolioItem> states = [];
    jsonList.forEach((json) {
      states.add(PortfolioItem.fromJson(json));
    });
    return states;
  }
}
