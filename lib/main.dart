import 'package:flutter/material.dart';
import 'package:lloud_mobile/providers/likes.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/products.dart';
import 'package:lloud_mobile/providers/search.dart';
import 'package:lloud_mobile/providers/store_items.dart';
import 'package:lloud_mobile/providers/showcase.dart';
import 'package:lloud_mobile/providers/loading.dart';
import 'package:lloud_mobile/providers/apn.dart';
import 'package:lloud_mobile/providers/notifications.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/providers/avatar.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/pages/signup/email.dart';
import 'package:lloud_mobile/views/pages/activity.dart';
import 'package:lloud_mobile/views/pages/store_item_page.dart';
import 'package:lloud_mobile/views/pages/login.dart';
import 'package:lloud_mobile/views/pages/edit_profile.dart';
import 'package:lloud_mobile/views/pages/shipping_info.dart';
import 'package:lloud_mobile/views/pages/options.dart';
import 'package:lloud_mobile/views/pages/profile.dart';
import 'package:lloud_mobile/views/pages/artist.dart';
import 'package:lloud_mobile/views/pages/audio_player.dart';
import 'package:lloud_mobile/views/pages/signup/username.dart';
import 'package:lloud_mobile/views/pages/signup/password.dart';
import 'package:lloud_mobile/views/pages/signup/welcome.dart';
import 'package:lloud_mobile/views/pages/nav.dart';
import 'package:lloud_mobile/routes.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://e81c4240f7584caebd543f7194ad7e1f@o513234.ingest.sentry.io/5614720';
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AudioPlayer _audioPlayerProvider = AudioPlayer();

  Future<void> initPaymentPlatform() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("XstlTtxLyLvhognmeAZyaVDIDSLQCFMy");
  }

  @override
  void initState() {
    initPaymentPlatform();
    _audioPlayerProvider.init();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayerProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Loading()),
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, StoreItems>(
            create: null,
            update: (context, auth, storeItems) =>
                storeItems == null ? StoreItems(auth.token) : storeItems),
        ChangeNotifierProxyProvider<Auth, Likes>(
            create: null,
            update: (context, auth, likes) {
              if (likes == null) {
                final likes = Likes(auth.token, auth.userId);
                likes.fetchAndSetLikes();
                return likes;
              }

              return likes;
            }),
        ChangeNotifierProxyProvider<Auth, Avatar>(
            create: null,
            update: (context, auth, avatar) =>
                avatar == null ? Avatar(auth.token, auth.userId) : avatar),
        ChangeNotifierProxyProvider<Auth, Search>(
            create: null,
            update: (context, auth, search) =>
                search == null ? Search(auth.token) : search),
        ChangeNotifierProxyProvider<Auth, Showcase>(
            create: null,
            update: (context, auth, showcase) =>
                showcase == null ? Showcase(auth.token) : showcase),
        ChangeNotifierProxyProvider<Auth, Apn>(
            create: null,
            update: (context, auth, apn) {
              if (apn == null) {
                final apnProv = Apn(auth.token, auth.userId);
                apnProv.init();
                return apnProv;
              }

              return apn;
            }),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: null,
            update: (context, auth, products) {
              if (products == null) {
                final newProducts = Products();
                newProducts.fetchAndSetProduct();
                return newProducts;
              }

              return products;
            }),
        ChangeNotifierProxyProvider<Auth, Notifications>(
            create: null,
            update: (context, auth, notifications) {
              if (notifications == null) {
                final notifs = Notifications(auth.token, auth.userId);
                notifs.listenForUnreadNotifications();
                return notifs;
              }

              return notifications;
            }),
        ChangeNotifierProxyProvider<Auth, AudioPlayer>(
            create: null,
            update: (context, auth, audio) {
              if (audio == null) {
                _audioPlayerProvider.authToken = auth.token;
                return _audioPlayerProvider;
              }

              return audio;
            }),
      ],
      child: MaterialApp(
        title: 'Lloud',
        initialRoute: Routes.home,
        home: Consumer<Auth>(
          builder: (context, auth, _) {
            return auth.isAuth
                ? NavPage.fromData()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? LoadingScreen()
                            : EmailPage());
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Lato'),
        routes: {
          // Normal routes
          Routes.login: (ctx) => LoginPage(),
          Routes.notifications: (ctx) => ActivityPage(),
          Routes.signup_username: (ctx) => UsernamePage(),
          Routes.signup_password: (ctx) => PasswordPage(),
          Routes.signup_welcome: (ctx) => WelcomePage(),
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
            // Routes that need arguments passed in
            Routes.artist: (ctx) => ArtistPage(settings.arguments),
            Routes.profile: (ctx) => ProfilePage(settings.arguments),
            Routes.store_item: (ctx) => StoreItemPage(settings.arguments),
            // '/forgot-password': (ctx) => ForgotPasswordPage(),
          };

          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
