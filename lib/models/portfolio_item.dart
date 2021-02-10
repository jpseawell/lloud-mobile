import 'package:flutter/foundation.dart';

import 'package:lloud_mobile/models/song.dart';

class PortfolioItem {
  final int id;
  final int pointsEarned;
  final Song song;

  const PortfolioItem({
    @required this.id,
    @required this.pointsEarned,
    @required this.song,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
        id: json['id'],
        pointsEarned: json['points_earned'],
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
