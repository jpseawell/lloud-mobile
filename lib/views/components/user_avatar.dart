import 'dart:convert';

import 'package:lloud_mobile/views/components/placeholder_avatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/util/network.dart';
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
  Future<ImageFile> profileImg;

  _UserAvatarState({this.userId, this.radius, this.darkIfEmpty = false});

  @override
  void initState() {
    profileImg =
        fetchProfileImage(Provider.of<Auth>(context, listen: false).token);
    super.initState();
  }

  Future<ImageFile> fetchProfileImage(String token) async {
    if (userId == 0 || userId == null) return ImageFile.empty();

    final url = '${Network.host}/api/v2/users/$userId';
    final res = await http.get(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedResponse = json.decode(res.body);

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
    return FutureBuilder<ImageFile>(
        future: profileImg,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              userId == null)
            return PlaceholderAvatar(
              radius: radius,
            );

          if (snapshot.data.location.isEmpty)
            return EmptyAvatar(
              initial: user.userName.substring(0, 1),
              radius: radius,
              isDark: darkIfEmpty,
            );

          return CircleAvatar(
              radius: radius,
              backgroundColor: darkIfEmpty
                  ? LloudTheme.black.withOpacity(.10)
                  : LloudTheme.white2.withOpacity(.10),
              backgroundImage:
                  NetworkImage(snapshot.data.location + '?tr=w-125,h-125'));
        });
  }
}
