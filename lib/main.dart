import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lloud_mobile/providers/song_player.dart';
import 'package:lloud_mobile/providers/points.dart';
import 'package:lloud_mobile/providers/user.dart';

import './views/pages/landing_page.dart';
import './views/pages/signup/signup_page.dart';
import './views/pages/signup/username_page.dart';
import './views/pages/signup/password_page.dart';
import './views/pages/signup/welcome_page.dart';
import './views/pages/login_page.dart';
import './views/pages/nav_page.dart';
import './views/pages/store_item_page.dart';
import './views/pages/subscription_page.dart';
import './providers/likes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // TODO: Add providers for: auth, playing audio
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Likes()),
          ChangeNotifierProvider(create: (_) => SongPlayer()),
          ChangeNotifierProvider(create: (_) => Points()),
          ChangeNotifierProvider(create: (_) => UserModel())
        ],
        child: MaterialApp(
            title: 'Lloud',
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (ctx) => LandingPage(),
              '/username': (ctx) => UsernamePage(),
              '/password': (ctx) => PasswordPage(),
              '/welcome': (ctx) => WelcomePage(),
              '/login': (ctx) => LoginPage(),
              '/nav': (ctx) => NavPage.fromData(),
              '/store': (ctx) => NavPage.fromData(
                    pageIndex: 2,
                  ),
              '/account': (ctx) => NavPage.fromData(
                    pageIndex: 3,
                  ),
              '/store-item': (ctx) => StoreItemPage(),
              '/subscription': (ctx) => SubscriptionPage(),
            }));
  }
}
