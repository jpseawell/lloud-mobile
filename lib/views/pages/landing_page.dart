import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/views/pages/signup/signup_page.dart';
import 'package:lloud_mobile/views/pages/nav_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Auth.loggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data;
            if (isLoggedIn) {
              Provider.of<UserModel>(context, listen: false).fetchUser();
              return NavPage.fromData();
            }
            return SignupPage();
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
