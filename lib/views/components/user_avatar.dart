import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/empty_avatar.dart';

class UserAvatar extends StatefulWidget {
  final int userId;
  final double radius;
  final Key key;
  final bool darkIfEmpty;

  UserAvatar(
      {this.userId, this.radius = 40, this.key, this.darkIfEmpty = false});

  @override
  _UserAvatarState createState() => _UserAvatarState(
      userId: this.userId, radius: this.radius, darkIfEmpty: this.darkIfEmpty);
}

class _UserAvatarState extends State<UserAvatar> {
  final int userId;
  final double radius;
  final bool darkIfEmpty;
  User user;
  Future<ImageFile> imageFile;

  _UserAvatarState({this.userId, this.radius, this.darkIfEmpty = false});

  @override
  void initState() {
    super.initState();
    imageFile = fetchProfileImage();
  }

  Future<ImageFile> fetchProfileImage() async {
    final response = await DAL.instance().fetch('users/$userId');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    if (decodedResponse['profileImg'] == null) {
      setState(() {
        user = User.fromJson(decodedResponse);
      });
      return ImageFile.empty();
    }

    return ImageFile.fromJson(decodedResponse['profileImg']);
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
                initial: user.userName.substring(0, 1),
                radius: radius,
                isDark: darkIfEmpty,
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
