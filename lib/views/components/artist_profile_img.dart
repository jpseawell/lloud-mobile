import 'package:flutter/material.dart';

import 'package:lloud_mobile/models/image_file.dart';

class ArtistProfileImage extends StatelessWidget {
  final ImageFile img;

  ArtistProfileImage({this.img});

  @override
  Widget build(BuildContext context) {
    if (img.location.isEmpty) return Container();

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(img.location + '?tr=w-300,h-300'),
                fit: BoxFit.fitWidth)),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color.fromRGBO(31, 31, 31, 1.0).withAlpha(0),
            Color.fromRGBO(31, 31, 31, 1.0).withAlpha(50),
            Color.fromRGBO(31, 31, 31, 1.0).withAlpha(250),
          ],
        )),
      ),
    ]);
  }
}
