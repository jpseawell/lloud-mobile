import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class BaseTemplate extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  BaseTemplate({this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.backgroundColor ?? LloudTheme.white,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(child: child),
    );
  }
}
