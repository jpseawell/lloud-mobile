import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './views/pages/signup_page.dart';
import './config/lloud_theme.dart';
import './providers/likes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // TODO: Add providers for: auth, playing audio, points
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => Likes())],
        child: MaterialApp(
          title: 'Lloud',
          theme: LloudTheme.getThemeData(context),
          home: SignupPage(),
        ));
  }
}
