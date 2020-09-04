import 'package:flutter/material.dart';
// import 'package:lloud_mobile/views/_common/back_btn.dart';

class BackpageTemplate extends StatelessWidget {
  final List<Widget> content;

  BackpageTemplate(this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[BackBtn()]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            )
          ],
        ),
      ),
    );
  }
}
