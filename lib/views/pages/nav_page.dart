import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import '../../providers/likes.dart';
import '../pages/songs_page.dart';
import '../pages/portfolio_page.dart';
import '../pages/listener_account_page.dart';
import '../_common/nav_bar.dart';
import '../_common/total_points.dart';
import '../_common/remaining_likes.dart';

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
    PortfolioPage(),
    // StorePage(),
    ListenerAccountPage(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Likes>(context, listen: false).fetchLikes();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LloudTheme.black,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: RemainingLikes(),
            ),
            Expanded(
              flex: 1,
              child: TotalPoints(),
            ),
          ],
        ),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: NavBar(_selectPage, _selectedPageIndex),
    );
  }
}
