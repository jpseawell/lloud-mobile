import 'package:flutter/material.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/views/_common/listener_account_form.dart';

class EditPersonalInfoPage extends StatefulWidget {
  @override
  _EditPersonalInfoPageState createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserModel>(context).user;
    return Scaffold(
      body: SafeArea(child: ListenerAccountForm(user)),
    );
  }
}
