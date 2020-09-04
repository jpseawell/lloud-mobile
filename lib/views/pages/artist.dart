import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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

  _ArtistPageState(this._artistId);

  @override
  void initState() {
    super.initState();
    artistProfile = fetchArtistProfile();
  }

  Future<ArtistProfile> fetchArtistProfile() async {
    final response =
        await DAL.instance().fetch('artists/${_artistId.toString()}');

    if (response.statusCode == 200) {
      ArtistProfile ap = ArtistProfile.fromJson(json.decode(response.body));

      setState(() {
        thisProfile = ap;
      });

      return ap;
    }
  }

  String getPlaylistKey() {
    return 'artist:${_artistId.toString()}';
  }

  Widget songWidgetBuilder(ArtistProfile ap) {
    return ListView.builder(
        itemCount: ap.songs.length,
        itemBuilder: (context, i) {
          return SongWidgetSmall(i, ap.songs[i]);
        });
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

    return Scaffold(
      backgroundColor: LloudTheme.blackLight,
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
                                image: NetworkImage(ap.profileImg),
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
      ap.stopAndClearPlaylist();
      ap.playlistKey = getPlaylistKey();
      ap.addSongsToPlaylist(thisProfile.songs);
    }

    if (ap.currentSong == null || ap.currentSong.id != song.id) {
      return ap.findAndPlay(index);
    }

    (ap.isPlaying) ? ap.pause() : ap.resume();
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
            height: 8,
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
