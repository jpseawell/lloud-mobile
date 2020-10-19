import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/components/buttons/home_btn.dart';
import 'package:lloud_mobile/views/components/profile_nav.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/account_balances_bar.dart';
import 'package:lloud_mobile/views/components/h2.dart';
import 'package:lloud_mobile/views/components/inline_buy_btn.dart';
import 'package:lloud_mobile/views/components/portfolio_item_widget.dart';
import 'package:lloud_mobile/views/components/profile_bar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  final bool isMyProfile;

  ProfilePage(this.userId, {this.isMyProfile = false});

  @override
  _ProfilePageState createState() =>
      _ProfilePageState(this.userId, isMyProfile: this.isMyProfile);
}

class _ProfilePageState extends State<ProfilePage> {
  final int userId;
  final bool isMyProfile;
  ScrollController scrollController;
  List<PortfolioItem> portfolioItems = [];
  bool isFetching = false;
  int currentPage = 1;

  _ProfilePageState(this.userId, {this.isMyProfile = false});

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(shouldFetch);
    fetchItems(context, currentPage);
  }

  void shouldFetch() {
    if (isFetching) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      fetchItems(context, currentPage);
    }
  }

  Future<void> fetchItems(BuildContext context, int requestedPage) async {
    setState(() {
      isFetching = !isFetching;
    });

    String url =
        'user/${userId.toString()}/likes?page=${requestedPage.toString()}';
    final response = await DAL.instance().fetch(url);
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    if (decodedResponse['status'] == 'success') {
      portfolioItems
          .addAll(PortfolioItem.fromJsonList(decodedResponse['data']['likes']));
    }

    setState(() {
      isFetching = !isFetching;
      currentPage += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMyProfile
          ? null
          : ProfileNav(
              userId: userId,
            ),
      backgroundColor: LloudTheme.white2,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: homeButton(),
      body: SafeArea(
          child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: IntrinsicHeight(
            child: Column(
          children: [
            ProfileBar(
              userId: userId,
              isMyProfile: isMyProfile,
            ),
            SizedBox(
              height: 8,
            ),
            accountBalances(),
            buyBtn(),
            Expanded(child: portfolio())
          ],
        )),
      )),
    );
  }

  String getPlaylistKey() {
    return 'portfolio:${userId.toString()}';
  }

  Widget homeButton() {
    if (isMyProfile) {
      return Container();
    }

    return HomeButton(
      isDark: true,
    );
  }

  Widget portfolio() {
    int index = 0;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Stack(
        children: [
          Column(
            children: [
              portfolioHeader(),
              // TODO: Debug why song won't play on tap?
              portfolioItemWidgets()
            ],
          )
        ],
      ),
    );
  }

  Widget portfolioItemWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < portfolioItems.length; i++) {
      list.add(PortfolioItemWidget(
        portfolioItem: portfolioItems[i],
        index: i,
        onTapCB: playSong,
      ));
    }
    return Column(
      children: list,
    );
  }

  void playSong(BuildContext ctx, int index, Song song) {
    AudioProvider audioProvider =
        Provider.of<AudioProvider>(ctx, listen: false);

    if (audioProvider.playlistKey != getPlaylistKey()) {
      bool wasActiveBeforeNewPlaylistLoaded = audioProvider.isActive(song);
      audioProvider.isBeingPlayed(song)
          ? audioProvider.pause()
          : audioProvider.resume();

      audioProvider.setPlaylist(
          getPlaylistKey(), Song.fromPortfolioItemList(portfolioItems));

      if (wasActiveBeforeNewPlaylistLoaded) {
        return;
      }
    }

    if (!audioProvider.isActive(song)) {
      return audioProvider.findAndPlay(index);
    }

    audioProvider.isBeingPlayed(song)
        ? audioProvider.pause()
        : audioProvider.resume();
  }

  int portfolioTotal() {
    var total = 0;
    for (var item in portfolioItems) {
      total += item.points_earned;
    }
    return total;
  }

  String pronoun() {
    if (isMyProfile) {
      return 'You\'ve';
    }

    return 'This user';
  }

  Widget portfolioHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H2('Portfolio'),
          SizedBox(
            height: 4,
          ),
          Text(
            '${pronoun()} liked ${portfolioItems.length} songs and earned a total of ${portfolioTotal()} points!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget accountBalances() {
    if (!isMyProfile) {
      return Container();
    }

    return AccountBalancesBar();
  }

  Widget buyBtn() {
    if (!isMyProfile) {
      return Container();
    }

    return Row(
      children: [
        Expanded(flex: 1, child: InlineBuyBtn()),
      ],
    );
  }
}
