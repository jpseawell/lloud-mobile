import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        width: 145.0,
        child: Image.asset('assets/Lloud.png'));
  }
}
