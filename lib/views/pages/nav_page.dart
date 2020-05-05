import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import 'package:lloud_mobile/views/_common/nav_logo.dart';
import 'package:lloud_mobile/views/pages/store_page.dart';

import 'package:lloud_mobile/providers/points.dart';
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
  final int _pageIndex;
  NavPage.fromData({int pageIndex = 0}) : _pageIndex = pageIndex;

  @override
  _NavPageState createState() => _NavPageState(this._pageIndex);
}

class _NavPageState extends State<NavPage> {
  int pageIndex;
  _NavPageState(this.pageIndex);

  final List<Widget> _pages = [
    SongsPage(),
    PortfolioPage(),
    StorePage(),
    ListenerAccountPage(),
  ];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    if (pageIndex != null) {
      _selectedPageIndex = pageIndex;
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Likes>(context, listen: false).fetchLikes();
    Provider.of<Points>(context, listen: false).fetchPoints();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: LloudTheme.black,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: RemainingLikes(),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: NavLogo(),
              ),
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
