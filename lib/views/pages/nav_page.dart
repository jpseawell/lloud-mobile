import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import '../pages/songs_page.dart';
import '../_common/nav_bar.dart';

///
/// The NavPage is the 'root' page of the application.
///
/// It acts as a shell for navigating back
/// and forth between the four main pages.
///

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  final List<Widget> _pages = [
    SongsPage(),
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
        backgroundColor: LloudTheme.black,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                    child: Icon(Icons.favorite),
                  ),
                  Text('3/5', style: TextStyle(fontWeight: FontWeight.w300))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                    child: Icon(Icons.score),
                  ),
                  Text('2,356', style: TextStyle(fontWeight: FontWeight.w300))
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: NavBar(_selectPage),
    );
  }
}
