import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/views/components/portfolio_header.dart';
import 'package:lloud_mobile/views/components/portfolio_item_widget.dart';
import 'package:lloud_mobile/views/components/profile_bar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/buttons/home_btn.dart';
import 'package:lloud_mobile/views/components/profile_nav.dart';
import 'package:lloud_mobile/providers/likes.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage(this.userId);

  @override
  _ProfilePageState createState() => _ProfilePageState(this.userId);
}

class _ProfilePageState extends State<ProfilePage> {
  final int userId;
  ScrollController _scrollController;
  bool _isFetching = true;
  int _currentPage = 1;

  _ProfilePageState(this.userId);

  @override
  void initState() {
    Provider.of<Likes>(context, listen: false)
        .resetLikes(overrideUserId: userId)
        .then((_) {
      setState(() {
        _isFetching = false;
      });
    });
    _scrollController = ScrollController();
    _scrollController.addListener(shouldFetch);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(shouldFetch);
    _scrollController.dispose();
    super.dispose();
  }

  void shouldFetch() {
    if (_isFetching) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 160 &&
        !_scrollController.position.outOfRange) {
      fetchItems();
    }
  }

  Future<void> fetchItems() async {
    setState(() {
      _isFetching = true;
      _currentPage = _currentPage + 1;
    });

    await Provider.of<Likes>(context, listen: false)
        .fetchAndSetLikes(page: _currentPage, overrideUserId: userId);

    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Likes>(context).items;

    return Scaffold(
      backgroundColor: LloudTheme.white2,
      appBar: ProfileNav(userId: userId),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: HomeButton(isDark: true),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: CustomScrollView(controller: _scrollController, slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  ProfileBar(userId: userId),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: PortfolioHeader(items, isMyProfile: false),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return PortfolioItemWidget(
                    portfolioItem: items[index],
                    onPlay: handlePlay,
                  );
                }, childCount: items.length)),
                if (_isFetching)
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red),
                    ))
                  ]))
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    final sourceKey = getSourceKey();
    if (!audioPlayer.isSourcedFrom(sourceKey)) {
      final portfolioItems = Provider.of<Likes>(context, listen: false).items;
      audioPlayer.setPlaylistFromNewSource(
          sourceKey, Song.fromPortfolioItemList(portfolioItems));
    }
    await audioPlayer.togglePlay(song);
  }

  String getSourceKey() {
    return 'profile:$userId';
  }
}
