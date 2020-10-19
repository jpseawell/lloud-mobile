import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/views/pages/profile.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User me = Provider.of<UserProvider>(context).user;
    return ProfilePage(
      me.id,
      isMyProfile: true,
    );
  }
}
