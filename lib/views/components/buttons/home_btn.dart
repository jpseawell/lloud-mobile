import 'package:flutter/material.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class HomeButton extends StatelessWidget {
  final bool isDark;

  HomeButton({this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 3,
      onPressed: () {
        Navigator.pushNamed(context, Routes.songs);
      },
      color: isDark
          ? LloudTheme.blackLight.withOpacity(.85)
          : LloudTheme.white2.withOpacity(.85),
      textColor: isDark ? LloudTheme.white2 : LloudTheme.blackLight,
      child: Icon(
        Icons.home,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }
}
