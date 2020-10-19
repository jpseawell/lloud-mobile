import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/empty_avatar.dart';

class UserAvatar extends StatefulWidget {
  final int userId;
  final double radius;

  UserAvatar({this.userId, this.radius = 40});

  @override
  _UserAvatarState createState() =>
      _UserAvatarState(userId: this.userId, radius: this.radius);
}

class _UserAvatarState extends State<UserAvatar> {
  final int userId;
  final double radius;
  Future<ImageFile> imageFile;

  _UserAvatarState({this.userId, this.radius});

  @override
  void initState() {
    super.initState();
    imageFile = fetchProfileImage();
  }

  Future<ImageFile> fetchProfileImage() async {
    final response = await DAL
        .instance()
        .fetch('user/${this.userId.toString()}/image-files');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    if (decodedResponse['data']['imageFile'] == null) {
      return ImageFile.empty();
    }

    return ImageFile.fromJson(decodedResponse['data']['imageFile']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<ImageFile>(
          future: imageFile,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red));
            }

            ImageFile img = snapshot.data;

            if (img.location.isEmpty) {
              return EmptyAvatar(
                radius: radius,
              );
            }

            return CircleAvatar(
                radius: radius,
                backgroundColor: LloudTheme.red,
                backgroundImage: NetworkImage(img.location));
          }),
    );
  }
}
