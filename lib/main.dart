import 'package:flutter/material.dart';
import 'package:lloud_mobile/providers/song_player.dart';
import 'package:provider/provider.dart';

import './views/pages/signup/signup_page.dart';
import './views/pages/signup/username_page.dart';
import './views/pages/signup/password_page.dart';
import './views/pages/signup/welcome_page.dart';
import './views/pages/login_page.dart';
import './views/pages/nav_page.dart';
import './providers/likes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // TODO: Add providers for: auth, playing audio, points
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Likes()),
          ChangeNotifierProvider(create: (_) => SongPlayer())
        ],
        child: MaterialApp(
            title: 'Lloud',
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (ctx) => SignupPage(),
              '/username': (ctx) => UsernamePage(),
              '/password': (ctx) => PasswordPage(),
              '/welcome': (ctx) => WelcomePage(),
              '/login': (ctx) => LoginPage(),
              '/nav': (ctx) => NavPage(),
            }));
  }
}
