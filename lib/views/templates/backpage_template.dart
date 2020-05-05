import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/_common/h1.dart';

class BackpageTemplate extends StatelessWidget {
  final List<Widget> content;

  BackpageTemplate(this.content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '< Back to Store',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, color: LloudTheme.red),
                  ))
            ]),
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
