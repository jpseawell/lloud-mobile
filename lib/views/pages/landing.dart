import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/providers/account.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/pages/nav.dart';
import 'package:lloud_mobile/views/pages/signup/email.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Auth.loggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data;
            if (isLoggedIn) {
              Provider.of<UserProvider>(context, listen: false)
                  .fetchAndNotify();
              Provider.of<AccountProvider>(context, listen: false)
                  .fetchAndNotify();
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
