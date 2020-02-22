import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Function ontap;

  NavBar(this.ontap);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: this.ontap,
      selectedItemColor: Color.fromRGBO(255, 64, 64, 1.0),
      unselectedItemColor: Color.fromRGBO(28, 28, 28, 1.0),
      items: [
        BottomNavigationBarItem(
            title: Text('Songs'), icon: Icon(Icons.queue_music)),
        BottomNavigationBarItem(
            title: Text('Portfolio'), icon: Icon(Icons.assessment)),
        BottomNavigationBarItem(title: Text('Store'), icon: Icon(Icons.store)),
        BottomNavigationBarItem(
            title: Text('Account'), icon: Icon(Icons.person)),
      ],
    );
  }
}
