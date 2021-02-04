import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/components/display_name.dart';
import 'package:lloud_mobile/views/components/my_avatar.dart';
import 'package:lloud_mobile/views/components/user_avatar.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/providers/auth.dart';

class MyProfileBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.edit_profile);
            },
            child: MyAvatar(darkIfEmpty: true),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DisplayName(auth.user)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ButtonTheme(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 24,
                child: OutlineButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.options);
                  },
                  child: Icon(
                    Icons.settings,
                    size: 16,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
