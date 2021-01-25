import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/components/artist_supporter.dart';

class ArtistSupporterList extends StatelessWidget {
  final List<dynamic> supporters;
  int rank = 1;

  ArtistSupporterList({this.supporters});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        for (var supporter in supporters)
          ArtistSupporterWidget(userId: supporter['id'], rank: rank++)
      ],
    );
  }
}
