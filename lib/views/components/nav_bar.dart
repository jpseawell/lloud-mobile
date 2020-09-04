import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class NavBar extends StatelessWidget {
  final Function ontap;
  final int selectedPageIndex;

  NavBar(this.ontap, this.selectedPageIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: this.ontap,
      selectedItemColor: LloudTheme.red,
      unselectedItemColor: LloudTheme.black,
      items: [
        BottomNavigationBarItem(
            title: Text('Songs'), icon: Icon(Icons.queue_music)),
        BottomNavigationBarItem(
            title: Text('Explore'), icon: Icon(Icons.search)),
        BottomNavigationBarItem(title: Text('Store'), icon: Icon(Icons.store)),
        BottomNavigationBarItem(
            title: Text('Account'), icon: Icon(Icons.person)),
      ],
    );
  }
}
