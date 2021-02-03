import 'package:flutter/material.dart';
import 'package:lloud_mobile/providers/loading.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/apn.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/views/components/top_nav.dart';
import 'package:lloud_mobile/views/components/nav_bar.dart';
import 'package:lloud_mobile/views/components/audio_bar.dart';
import 'package:lloud_mobile/views/pages/songs.dart';
import 'package:lloud_mobile/views/pages/explore.dart';
import 'package:lloud_mobile/views/pages/my_profile.dart';
import 'package:lloud_mobile/views/pages/store_page.dart';

///
/// The NavPage is the 'root' page of the application.
///
/// It acts as a shell for navigating back
/// and forth between the four main pages:
/// Home, Search, Store, Profile
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
    ExplorePage(),
    StorePage(),
    MyProfilePage()
  ];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    if (pageIndex != null) {
      _selectedPageIndex = pageIndex;
    }
    final authProvider = Provider.of<Auth>(context, listen: false);
    authProvider.fetchAndSetAccount(authProvider.token);

    Provider.of<Apn>(context, listen: false);

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool songLoaded =
        (Provider.of<AudioPlayer>(context).currentSong != null);

    return Stack(children: [
      Scaffold(
        appBar: TopNav(),
        body: Stack(
          children: <Widget>[
            // TODO: See if there's a more natural way to set this up
            Container(
              margin: EdgeInsets.only(bottom: (songLoaded) ? 64 : 0),
              child: _pages[_selectedPageIndex],
            ),
            if (songLoaded)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[AudioBar()],
              ),
          ],
        ),
        bottomNavigationBar: NavBar(_selectPage, _selectedPageIndex),
      ),
      if (Provider.of<Loading>(context).loading) LoadingScreen()
    ]);
  }
}
