import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/services/likes_service.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/views/components/portfolio_header.dart';
import 'package:lloud_mobile/views/components/portfolio_item_widget.dart';
import 'package:lloud_mobile/views/components/profile_bar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/buttons/home_btn.dart';
import 'package:lloud_mobile/views/components/profile_nav.dart';

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
  List<PortfolioItem> _likes = [];

  _ProfilePageState(this.userId);

  @override
  void initState() {
    refresh();
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
    final sourceKey = getSourceKey();
    if (audioPlayer.isSourcedFrom(sourceKey))
      audioPlayer.loadPlaylistFromSource(
          sourceKey, Song.fromPortfolioItemList(_likes));
  }

  Future<void> fetchItems() async {
    setState(() {
      _isFetching = true;
    });

    final authProvider = Provider.of<Auth>(context, listen: false);

    List<PortfolioItem> fetchedLikes = [];

    try {
      fetchedLikes = await LikesService.fetchLikes(authProvider.token, userId,
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
    final sourceKey = getSourceKey();
    if (!audioPlayer.isSourcedFrom(sourceKey)) {
      await audioPlayer.stop();
      audioPlayer.clearCurrentSong();
      audioPlayer.loadPlaylistFromSource(
          sourceKey, Song.fromPortfolioItemList(_likes));
    }
    await audioPlayer.playOrPause(song);
  }

  @override
  Widget build(BuildContext context) {
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
                    child: PortfolioHeader(userId, isMyProfile: false),
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

  String getSourceKey() {
    return 'profile:$userId';
  }
}
