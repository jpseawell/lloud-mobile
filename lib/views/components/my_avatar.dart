import 'package:flutter/material.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/views/components/empty_avatar.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/providers/user.dart';

class MyAvatar extends StatelessWidget {
  final double radius;

  MyAvatar({this.radius = 40});

  @override
  Widget build(BuildContext context) {
    ImageFile profileImg = Provider.of<UserProvider>(context).profileImg;
    if (profileImg == null) {
      User user = Provider.of<UserProvider>(context).user;
      return EmptyAvatar(
        initial: user.userName.substring(0, 1),
        radius: radius,
        isDark: true,
      );
    }

    return CircleAvatar(
        radius: radius,
        backgroundColor: LloudTheme.red,
        backgroundImage: NetworkImage(profileImg.location));
  }
}
