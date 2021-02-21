import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/loading.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
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
  final ScrollController _homeController = ScrollController();
  final ScrollController _storeController = ScrollController();
  final ScrollController _myProfileController = ScrollController();

  _NavPageState(this.pageIndex);

  List<Widget> _pages;
  List<ScrollController> _controllers;

  int pageIndex;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      SongsPage(_homeController),
      ExplorePage(),
      StorePage(_storeController),
      MyProfilePage(_myProfileController)
    ];

    _controllers = [
      _homeController,
      null,
      _storeController,
      _myProfileController
    ];

    if (pageIndex != null) {
      _selectedPageIndex = pageIndex;
    }

    Provider.of<Auth>(context, listen: false).fetchAndSetAccount();
    Provider.of<Apn>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _homeController.dispose();
    _storeController.dispose();
    _myProfileController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    final controller = _controllers[index];

    if (controller != null && _selectedPageIndex == index) {
      controller.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
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
            Container(
              margin: EdgeInsets.only(bottom: (songLoaded) ? 64 : 0),
              child: _pages[_selectedPageIndex],
            ),
            if (songLoaded)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [AudioBar()],
              ),
          ],
        ),
        bottomNavigationBar: NavBar(_selectPage, _selectedPageIndex),
      ),
      if (Provider.of<Loading>(context).loading) LoadingScreen()
    ]);
  }
}
