import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/likes.dart';
import 'package:lloud_mobile/views/components/inline_buy_btn.dart';
import 'package:lloud_mobile/views/components/my_profile_bar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/account_balances_bar.dart';
import 'package:lloud_mobile/views/components/portfolio_header.dart';
import 'package:lloud_mobile/views/components/portfolio_item_widget.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String _sourceKey = 'my_profile';
  ScrollController _scrollController;
  bool _isFetching = true;
  int _currentPage = 1;

  @override
  void initState() {
    Provider.of<Likes>(context, listen: false).resetLikes().then((_) {
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
        .fetchAndSetLikes(page: _currentPage);

    setState(() {
      _isFetching = false;
    });
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    if (!audioPlayer.isSourcedFrom(_sourceKey)) {
      final portfolioItems = Provider.of<Likes>(context, listen: false).items;
      audioPlayer.setPlaylistFromNewSource(
          _sourceKey, Song.fromPortfolioItemList(portfolioItems));
    }
    await audioPlayer.togglePlay(song);
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Likes>(context).items;

    return Scaffold(
      backgroundColor: LloudTheme.white2,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: CustomScrollView(controller: _scrollController, slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  MyProfileBar(),
                  Container(
                      margin: EdgeInsets.only(top: 8),
                      child: AccountBalancesBar()),
                  Row(
                    children: [
                      Expanded(flex: 1, child: InlineBuyBtn()),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: PortfolioHeader(items, isMyProfile: true),
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
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(LloudTheme.red),
                      ),
                    )
                  ]))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
