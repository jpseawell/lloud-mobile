import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Function ontap;

  NavBar(this.ontap);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: this.ontap,
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(
            title: Text('Songs'), icon: Icon(Icons.queue_music)),
        BottomNavigationBarItem(
            title: Text('Portfolio'), icon: Icon(Icons.graphic_eq)),
        BottomNavigationBarItem(
            title: Text('Store'), icon: Icon(Icons.queue_music)),
        BottomNavigationBarItem(
            title: Text('Account'), icon: Icon(Icons.queue_music)),
      ],
    );
  }
}
