import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/_common/listener_account_form.dart';
import 'package:lloud_mobile/providers/user.dart';

class ListenerAccountPage extends StatefulWidget {
  @override
  _ListenerAccountPageState createState() => _ListenerAccountPageState();
}

class _ListenerAccountPageState extends State<ListenerAccountPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user;
    return ListenerAccountForm(user);
  }
}
