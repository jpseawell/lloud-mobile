import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/pages/activity.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:lloud_mobile/views/pages/store_item_page.dart';
import 'package:lloud_mobile/views/pages/login.dart';
import 'package:lloud_mobile/views/pages/edit_profile.dart';
import 'package:lloud_mobile/views/pages/shipping_info.dart';
import 'package:lloud_mobile/views/pages/options.dart';
import 'package:lloud_mobile/views/pages/profile.dart';
import 'package:lloud_mobile/views/pages/artist.dart';
import 'package:lloud_mobile/views/pages/landing.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/keys.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/providers/account.dart';
import 'package:lloud_mobile/views/pages/audio_player.dart';
import 'package:lloud_mobile/views/pages/signup/username.dart';
import 'package:lloud_mobile/views/pages/signup/password.dart';
import 'package:lloud_mobile/views/pages/signup/welcome.dart';
import 'package:lloud_mobile/views/pages/nav.dart';

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
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
      ],
      child: MaterialApp(
        title: 'Lloud',
        initialRoute: Routes.home,
        debugShowCheckedModeBanner: false,
        navigatorKey: Keys.navKey,
        theme: ThemeData(
            fontFamily: 'Lato'), // TODO: Correctly implement custom theme
        routes: {
          Routes.signup_username: (ctx) => UsernamePage(),
          Routes.signup_password: (ctx) => PasswordPage(),
          Routes.signup_welcome: (ctx) => WelcomePage(),
          Routes.home: (ctx) => LandingPage(),
          Routes.audio_player: (ctx) => AudioPlayerPage(),
          Routes.songs: (ctx) => NavPage.fromData(),
          Routes.options: (ctx) => OptionsPage(),
          Routes.my_profile: (ctx) => NavPage.fromData(
                pageIndex: 3,
              ),
          Routes.store: (ctx) => NavPage.fromData(
                pageIndex: 2,
              ),
          Routes.edit_profile: (ctx) => EditProfile(),
          Routes.shipping_info: (ctx) => ShippingInfo(),
        },
        onGenerateRoute: (RouteSettings settings) {
          var routes = <String, WidgetBuilder>{
            Routes.login: (ctx) => LoginPage(),
            Routes.notifications: (ctx) => ActivityPage(),
            // '/forgot-password': (ctx) => ForgotPasswordPage(),
            Routes.artist: (ctx) => ArtistPage(settings.arguments),
            Routes.profile: (ctx) => ProfilePage(settings.arguments),
            // '/store': (ctx) => NavPage.fromData(
            //       pageIndex: 2,
            //     ),
            // '/account': (ctx) => NavPage.fromData(
            //       pageIndex: 3,
            //     ),
            // '/edit-personal-info': (ctx) => EditPersonalInfoPage(),
            Routes.store_item: (ctx) => StoreItemPage(settings.arguments),
            // '/likes': (ctx) => LikesPage(),
            // '/subscription': (ctx) => SubscriptionPage(),
            // '/subscription-error': (ctx) => SubscriptionErrorPage(),
            // '/subscription-success': (ctx) => SubscriptionSuccessPage(),
          };

          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
