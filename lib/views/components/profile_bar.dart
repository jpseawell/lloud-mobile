import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/my_avatar.dart';
import 'package:lloud_mobile/views/components/user_avatar.dart';

class ProfileBar extends StatefulWidget {
  final int userId;
  final bool isMyProfile;

  ProfileBar({@required this.userId, this.isMyProfile = false});

  @override
  _ProfileBarState createState() =>
      _ProfileBarState(userId: this.userId, isMyProfile: this.isMyProfile);
}

class _ProfileBarState extends State<ProfileBar> {
  final int userId;
  final bool isMyProfile;
  Future<User> user;

  _ProfileBarState({@required this.userId, this.isMyProfile = false});

  Future<User> fetchUser() async {
    final response = await DAL.instance().fetch('users/${userId.toString()}');

    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));

      return user;
    }
  }

  @override
  void initState() {
    super.initState();
    user = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red));
          }

          User thisUser = snapshot.data;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatar(thisUser),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: displayName(thisUser),
                  ),
                ),
              ),
              settingsBtn(context)
            ],
          );
        });
  }

  Widget avatar(User user) {
    if (isMyProfile) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.edit_profile);
        },
        child: MyAvatar(),
      );
    }

    return UserAvatar(
      userId: user.id,
      darkIfEmpty: true,
    );
  }

  List<Widget> displayName(User user) {
    if (user.firstName == null) {
      return [
        Text('@${user.userName}',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
      ];
    }

    if (user.lastName == null) {
      return [
        Text(user.firstName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
      ];
    }

    return [
      Text('${user.firstName} ${user.lastName}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(
        height: 4,
      ),
      Text('@${user.userName}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300))
    ];
  }

  Widget settingsBtn(BuildContext context) {
    if (!isMyProfile) {
      return Container();
    }

    return Container(
      child: Column(
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
      ),
    );
  }
}
