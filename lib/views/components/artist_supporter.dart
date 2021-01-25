import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/components/user_avatar.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/providers/auth.dart';

class ArtistSupporterWidget extends StatelessWidget {
  final int userId, rank;

  ArtistSupporterWidget({this.userId, this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          if (Provider.of<Auth>(context, listen: false).userId == userId) {
            Navigator.of(context).pushNamed(Routes.my_profile);
            return;
          }

          Navigator.of(context).pushNamed(Routes.profile, arguments: userId);
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                UserAvatar(
                  userId: userId,
                ),
                Text(
                  '$rank.',
                  style: TextStyle(
                      color: LloudTheme.white.withOpacity(.75),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
