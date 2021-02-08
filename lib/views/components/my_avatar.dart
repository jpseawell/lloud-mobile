import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/views/components/empty_avatar.dart';
import 'package:lloud_mobile/views/components/placeholder_avatar.dart';
import 'package:lloud_mobile/providers/avatar.dart';

class MyAvatar extends StatefulWidget {
  final double radius;
  final bool darkIfEmpty;

  MyAvatar({this.radius = 40, this.darkIfEmpty = false});

  @override
  _MyAvatarState createState() => _MyAvatarState();
}

class _MyAvatarState extends State<MyAvatar> {
  @override
  void initState() {
    Provider.of<Avatar>(context, listen: false).fetchAndSetImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Consumer<Avatar>(builder: (context, avatar, _) {
      if (avatar.image == null || !authProvider.isAuth)
        return PlaceholderAvatar(radius: widget.radius);

      if (avatar.image.location.isEmpty) {
        return EmptyAvatar(
          initial: authProvider.user.userName.substring(0, 1),
          radius: widget.radius,
          isDark: widget.darkIfEmpty,
        );
      }

      return CircleAvatar(
          radius: widget.radius,
          backgroundColor: LloudTheme.blackLight,
          backgroundImage:
              NetworkImage(avatar.image.location + '?tr=w-125,h-125'));
    });
  }
}
