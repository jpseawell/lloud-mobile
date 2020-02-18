import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> _pages = [
    // SongsPage(),
    // PortfolioPage(),
    // StorePage(),
    // ListenerAccountPage(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holla'),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.queue_music)),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq)),
          BottomNavigationBarItem(icon: Icon(Icons.queue_music)),
          BottomNavigationBarItem(icon: Icon(Icons.queue_music)),
        ],
      ),
    );
  }
}
