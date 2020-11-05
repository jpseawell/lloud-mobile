import 'dart:convert';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/views/components/buttons/home_btn.dart';
import 'package:lloud_mobile/views/components/user_avatar.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/models/artist.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/artist_profile.dart';
import 'package:lloud_mobile/views/components/h1.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';
import 'package:lloud_mobile/views/components/song_widget_sm.dart';

class ArtistPage extends StatefulWidget {
  final int artistId;
  ArtistPage(this.artistId);

  @override
  _ArtistPageState createState() => _ArtistPageState(this.artistId);
}

class _ArtistPageState extends State<ArtistPage> {
  final int _artistId;
  final double _horizontalPadding = 16.0;
  Future<ArtistProfile> artistProfile;
  ArtistProfile thisProfile;
  List<dynamic> supporters;

  _ArtistPageState(this._artistId);

  @override
  void initState() {
    super.initState();
    artistProfile = fetchArtistProfile();
  }

  Future<ArtistProfile> fetchArtistProfile() async {
    final artistRes = await DAL.instance().fetch('artists/$_artistId');
    Map<String, dynamic> decodedArtistRes = json.decode(artistRes.body);
    Artist artist = Artist.fromJson(decodedArtistRes["data"]["artist"]);

    int likes = decodedArtistRes['data']['likes'];
    int plays = decodedArtistRes['data']['plays'];

    final imgRes = await DAL.instance().fetch('artist/$_artistId/image-files');
    Map<String, dynamic> decodedImgRes = json.decode(imgRes.body);
    ImageFile profileImg =
        ImageFile.fromJson(decodedImgRes['data']['imageFile']);

    final songsRes = await DAL.instance().fetch('artist/$_artistId/songs');
    Map<String, dynamic> songsResDecoded = json.decode(songsRes.body);

    List<Song> songs = [];
    if (songsResDecoded['data'] != null) {
      songs = Song.fromJsonList(songsResDecoded["data"]["songs"]);
    }

    ArtistProfile artistProfile = new ArtistProfile(
        artist: artist,
        songs: songs,
        likes: likes,
        plays: plays,
        profileImg: profileImg.location);

    final supportersRes =
        await DAL.instance().fetch('artist/$_artistId/supporters');
    Map<String, dynamic> decodedSupportersRes = json.decode(supportersRes.body);

    List<dynamic> decodedSupporters =
        decodedSupportersRes["data"]["supporters"];

    setState(() {
      thisProfile = artistProfile;
      supporters = decodedSupporters;
    });

    return artistProfile;
  }

  String getPlaylistKey() {
    return 'artist:$_artistId';
  }

  String formatNumber(int stat) {
    String statStr = stat.toString();

    if (statStr.length <= 3) {
      return statStr;
    }

    if (statStr.length > 6) {
      return '${statStr.substring(0, (statStr.length - 6))}M';
    }

    return '${statStr.substring(0, (statStr.length - 3))}K';
  }

  @override
  Widget build(BuildContext context) {
    const Key infoKey = ValueKey('info-sliver');
    const Key songsKey = ValueKey('songs-sliver');
    const Key aboutKey = ValueKey('about-sliver');
    const Key supportersKey = ValueKey('supporters-sliver');

    return Scaffold(
      backgroundColor: LloudTheme.blackLight,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: HomeButton(),
      body: SafeArea(
          child: FutureBuilder<ArtistProfile>(
        future: artistProfile,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          }

          ArtistProfile ap = snapshot.data;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                backgroundColor: LloudTheme.black,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding, vertical: 8),
                  title: H1(
                    ap.artist.name,
                    color: LloudTheme.white,
                  ),
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    ap.profileImg + '?tr=w-300,h-300'),
                                fit: BoxFit.fitWidth)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color.fromRGBO(31, 31, 31, 1.0).withAlpha(0),
                            Color.fromRGBO(31, 31, 31, 1.0).withAlpha(50),
                            Color.fromRGBO(31, 31, 31, 1.0).withAlpha(250),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                  key: infoKey,
                  delegate: SliverChildListDelegate.fixed(<Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: _horizontalPadding),
                      alignment: Alignment.topLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LikesStat(formatNumber(ap.likes)),
                          SizedBox(
                            width: 12,
                          ),
                          PlaysStat(formatNumber(ap.plays))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: _horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          H1(
                            'Songs',
                            color: LloudTheme.white,
                          ),
                        ],
                      ),
                    )
                  ])),
              SliverList(
                key: songsKey,
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: SongWidgetSmall(
                      index,
                      ap.songs[index],
                      onTapCB: playSong,
                    ),
                  );
                }, childCount: ap.songs.length),
              ),
              SliverList(
                  delegate: SliverChildListDelegate.fixed(<Widget>[
                Container(
                  margin: EdgeInsets.only(top: 32, bottom: 8),
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H1(
                        'Top Supporters',
                        color: LloudTheme.white,
                      ),
                    ],
                  ),
                )
              ])),
              SliverList(
                key: supportersKey,
                delegate: SliverChildListDelegate.fixed(<Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: supportersList(context),
                    ),
                  )
                ]),
              ),
              SliverList(
                  key: aboutKey,
                  delegate: SliverChildListDelegate.fixed(<Widget>[about(ap)]))
            ],
          );
        },
      )),
    );
  }

  void playSong(BuildContext ctx, int index, Song song) {
    AudioProvider ap = Provider.of<AudioProvider>(ctx, listen: false);

    if (ap.playlistKey != getPlaylistKey()) {
      bool wasActiveBeforeNewPlaylistLoaded = ap.isActive(song);
      ap.isBeingPlayed(song) ? ap.pause() : ap.resume();

      ap.setPlaylist(getPlaylistKey(), thisProfile.songs);

      if (wasActiveBeforeNewPlaylistLoaded) {
        return;
      }
    }

    if (!ap.isActive(song)) {
      return ap.findAndPlay(index);
    }

    ap.isBeingPlayed(song) ? ap.pause() : ap.resume();
  }

  List<Widget> supportersList(BuildContext context) {
    List<Widget> sups = [];
    int count = 1;

    for (var s in supporters) {
      sups.add(supporter(context, count, s));
      count++;
    }

    return sups;
  }

  Widget supporter(BuildContext context, int rank, dynamic user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          User me = Provider.of<UserProvider>(context, listen: false).user;
          if (me.id == user["id"]) {
            Navigator.of(context).pushNamed(Routes.my_profile);
            return;
          }

          Navigator.of(context)
              .pushNamed(Routes.profile, arguments: user["id"]);
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                UserAvatar(
                  userId: user['id'],
                ),
                Text(
                  '$rank.',
                  style: TextStyle(
                      color: LloudTheme.white.withOpacity(.75),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget about(ArtistProfile ap) {
    if (ap.artist.description == null &&
        (ap.artist.city == null || ap.artist.state == null)) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1(
            'About',
            color: LloudTheme.white,
          ),
          cityState(ap.artist.city, ap.artist.state),
          description(ap.artist.description),
          SizedBox(
            height: 64,
          )
        ],
      ),
    );
  }

  Widget description(String description) {
    if (description == null) {
      return Container();
    }

    return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          description,
          style: TextStyle(color: LloudTheme.white, height: 1.9, fontSize: 16),
        ));
  }

  Widget cityState(String city, String state) {
    if (city == null || state == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '$city, $state',
        style: TextStyle(color: LloudTheme.white, height: 1.9, fontSize: 16),
      ),
    );
  }
}
