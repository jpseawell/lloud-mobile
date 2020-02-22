import 'package:flutter/material.dart';

import './views/pages/signup_page.dart';
import './config/lloud_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lloud',
      theme: LloudTheme.getThemeData(context),
      home: SignupPage(),
    );
  }
}
