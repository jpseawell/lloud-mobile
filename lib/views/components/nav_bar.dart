import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/components/my_avatar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class NavBar extends StatelessWidget {
  final Function ontap;
  final int selectedPageIndex;

  NavBar(this.ontap, this.selectedPageIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: ontap,
      selectedItemColor: LloudTheme.red,
      unselectedItemColor: LloudTheme.black,
      items: [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: 'Explore', icon: Icon(Icons.search)),
        BottomNavigationBarItem(label: 'Shop', icon: Icon(Icons.store)),
        BottomNavigationBarItem(
            label: 'Profile', icon: MyAvatar(radius: 12, darkIfEmpty: true)),
      ],
    );
  }
}
