import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/h2.dart';

class InlineBuyBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      borderOnForeground: true,
      color: LloudTheme.red,
      child: Container(
        padding: EdgeInsets.all(8),
        height: 68,
        child: InkWell(
          splashColor: LloudTheme.white.withAlpha(30),
          onTap: () {
            print('bought');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get 10 Likes',
                style: TextStyle(
                    shadows: [
                      Shadow(
                          color: LloudTheme.black.withOpacity(.25),
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ],
                    color: LloudTheme.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                'for \$4.99',
                style: TextStyle(color: LloudTheme.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
