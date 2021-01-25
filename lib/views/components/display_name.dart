import 'package:flutter/material.dart';

import 'package:lloud_mobile/models/user.dart';

class DisplayName extends StatelessWidget {
  final User _user;

  DisplayName(this._user);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children;

    if (_user.firstName == null) {
      _children = [
        Text('@${_user.userName}',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
      ];
    } else if (_user.lastName == null) {
      _children = [
        Text(_user.firstName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
      ];
    } else {
      _children = [
        Text('${_user.firstName} ${_user.lastName}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 4,
        ),
        Text('@${_user.userName}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300))
      ];
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _children);
  }
}
