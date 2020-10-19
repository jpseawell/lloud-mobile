import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/providers/account.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/pages/nav.dart';
import 'package:lloud_mobile/views/pages/signup/email.dart';

class LandingPage extends StatelessWidget {
  Future<bool> hasAccess(BuildContext context) async {
    bool isLoggedIn = await Auth.loggedIn();
    if (!isLoggedIn) {
      return false;
    }

    await Provider.of<UserProvider>(context, listen: false).fetchAndNotify();
    await Provider.of<UserProvider>(context, listen: false)
        .fetchProfileImgAndNotify();
    await Provider.of<AccountProvider>(context, listen: false).fetchAndNotify();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: hasAccess(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data;
            if (isLoggedIn) {
              return NavPage.fromData();
            }
            return EmailPage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red)),
              ),
            );
          }
        });
  }
}
