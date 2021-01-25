import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class PlaceholderAvatar extends StatelessWidget {
  final double radius;

  PlaceholderAvatar({this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: radius, backgroundColor: LloudTheme.white);
  }
}
