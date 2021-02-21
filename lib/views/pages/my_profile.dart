import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/services/likes_service.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/models/song.dart';
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
  final String _sourceKey = 'my_profile';

  ScrollController _scrollController;
  bool _isFetching = true;
  int _currentPage = 1;
  List<PortfolioItem> _likes = [];

  @override
  void initState() {
    refresh().then((_) => loadSongsIntoAudioPlayer());
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
      fetchItems().then((_) => loadSongsIntoAudioPlayer());
    }
  }

  void loadSongsIntoAudioPlayer() {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    if (audioPlayer.isSourcedFrom(_sourceKey))
      audioPlayer.loadPlaylistFromSource(
          _sourceKey, Song.fromPortfolioItemList(_likes));
  }

  Future<void> fetchItems() async {
    setState(() {
      _isFetching = true;
    });

    final authProvider = Provider.of<Auth>(context, listen: false);

    List<PortfolioItem> fetchedLikes = [];

    try {
      fetchedLikes = await LikesService.fetchLikes(
          authProvider.token, authProvider.userId,
          page: _currentPage);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    List<PortfolioItem> likes = [..._likes];
    likes.addAll(fetchedLikes);

    setState(() {
      _likes = likes;
      _currentPage = _currentPage + 1;
      _isFetching = false;
    });
  }

  Future<void> refresh() async {
    setState(() {
      _currentPage = 1;
      _likes = [];
    });
    await fetchItems();
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    if (!audioPlayer.isSourcedFrom(_sourceKey)) {
      audioPlayer.loadPlaylistFromSource(
          _sourceKey, Song.fromPortfolioItemList(_likes));
    }
    await audioPlayer.playOrPause(song);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      backgroundColor: LloudTheme.white2,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
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
                    child:
                        PortfolioHeader(authProvider.userId, isMyProfile: true),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return PortfolioItemWidget(
                    portfolioItem: _likes[index],
                    onPlay: handlePlay,
                  );
                }, childCount: _likes.length)),
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
