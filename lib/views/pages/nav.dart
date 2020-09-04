import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/views/components/top_nav.dart';
import 'package:lloud_mobile/views/components/nav_bar.dart';
import 'package:lloud_mobile/views/pages/songs.dart';
import 'package:lloud_mobile/views/components/audio_bar.dart';

// import '../pages/portfolio_page.dart';
// import 'package:lloud_mobile/views/pages/store_page.dart';
// import '../pages/listener_account_page.dart';

///
/// The NavPage is the 'root' page of the application.
///
/// It acts as a shell for navigating back
/// and forth between the four main pages:
/// Songs, Search, Store, Profile
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
    // PortfolioPage(),
    // StorePage(),
    // ListenerAccountPage(),
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
    AudioProvider ap = Provider.of<AudioProvider>(context);

    return Scaffold(
      appBar: TopNav(),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: (ap.currentSong != null) ? 64 : 0),
            child: _pages[_selectedPageIndex],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              (ap.currentSong != null) ? AudioBar() : Container()
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavBar(_selectPage, _selectedPageIndex),
    );
  }
}
