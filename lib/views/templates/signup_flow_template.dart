import 'package:flutter/material.dart';

class SignupTemplate extends StatelessWidget {
  final List<Widget> content;

  SignupTemplate(this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: content,
        ),
      ),
    );
  }
}
