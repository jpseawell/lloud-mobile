import 'package:flutter/material.dart';

class BaseTemplate extends StatelessWidget {
  final Widget child;

  BaseTemplate({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: child),
    );
  }
}
