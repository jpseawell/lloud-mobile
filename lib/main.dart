import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:lloud_mobile/views/pages/edit_personal_info_page.dart';
import 'package:lloud_mobile/views/pages/forgot_password_page.dart';
import 'package:lloud_mobile/views/pages/subscription_success_page.dart';
import 'package:lloud_mobile/providers/song_player.dart';
import 'package:lloud_mobile/providers/points.dart';
import 'package:lloud_mobile/providers/user.dart';

import './views/pages/landing_page.dart';
import './views/pages/signup/username_page.dart';
import './views/pages/signup/password_page.dart';
import './views/pages/signup/welcome_page.dart';
import './views/pages/login_page.dart';
import './views/pages/nav_page.dart';
import './views/pages/store_item_page.dart';
import './views/pages/subscription_page.dart';
import './views/pages/subscription_error_page.dart';
import './views/pages/likes_page.dart';
import './providers/likes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPaymentPlatform();
  }

  Future<void> initPaymentPlatform() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("XstlTtxLyLvhognmeAZyaVDIDSLQCFMy");
  }

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
            theme: ThemeData(fontFamily: 'Lato'),
            routes: {
              '/': (ctx) => LandingPage(),
              '/username': (ctx) => UsernamePage(),
              '/password': (ctx) => PasswordPage(),
              '/welcome': (ctx) => WelcomePage(),
              '/login': (ctx) => LoginPage(),
              '/forgot-password': (ctx) => ForgotPasswordPage(),
              '/nav': (ctx) => NavPage.fromData(),
              '/store': (ctx) => NavPage.fromData(
                    pageIndex: 2,
                  ),
              '/account': (ctx) => NavPage.fromData(
                    pageIndex: 3,
                  ),
              '/edit-personal-info': (ctx) => EditPersonalInfoPage(),
              '/store-item': (ctx) => StoreItemPage(),
              '/likes': (ctx) => LikesPage(),
              '/subscription': (ctx) => SubscriptionPage(),
              '/subscription-error': (ctx) => SubscriptionErrorPage(),
              '/subscription-success': (ctx) => SubscriptionSuccessPage(),
            }));
  }
}
