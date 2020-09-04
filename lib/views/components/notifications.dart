import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class Notifications extends StatelessWidget {
  final int unreadNotifications;

  Notifications(this.unreadNotifications);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          height: 40,
          width: 40,
          child: Icon(Icons.favorite),
        ),
        Container(
          alignment: Alignment.topRight,
          height: 18,
          width: 18,
          child: ClipOval(
            child: Material(
              color: LloudTheme.red,
              child: SizedBox(
                  width: 18,
                  height: 18,
                  child: Center(
                    child: Text(
                      unreadNotifications.toString(),
                      style: TextStyle(color: LloudTheme.white),
                    ),
                  )),
            ),
          ),
        )
      ],
    );
  }
}
