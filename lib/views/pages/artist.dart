import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/services/artist_service.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/util/helpers.dart';
import 'package:lloud_mobile/views/components/artist_profile_img.dart';
import 'package:lloud_mobile/views/components/artist_supporter_list.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';
import 'package:lloud_mobile/views/components/song_widget_sm.dart';
import 'package:lloud_mobile/views/components/h1.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/buttons/home_btn.dart';

class ArtistPage extends StatefulWidget {
  final int artistId;
  ArtistPage(this.artistId);

  @override
  _ArtistPageState createState() => _ArtistPageState(this.artistId);
}

class _ArtistPageState extends State<ArtistPage> {
  final int artistId;
  ScrollController _scrollController;

  Future<Map<String, dynamic>> _artistProfile;
  Future<ImageFile> _profileImg;
  Future<List<dynamic>> _supporters;

  List<Song> _songs = [];
  int _likes = 0, _plays = 0;

  _ArtistPageState(this.artistId);

  @override
  void initState() {
    super.initState();
    final authToken = Provider.of<Auth>(context, listen: false).token;
    fetchSongs(authToken);
    _artistProfile = fetchArtistProfile(authToken);
    _profileImg = ArtistService.fetchImage(authToken, artistId);
    _supporters = ArtistService.fetchSupporters(authToken, artistId);
  }

  Future<Map<String, dynamic>> fetchArtistProfile(String authToken) async {
    final profile = await ArtistService.fetchArtistProfile(authToken, artistId);
    setState(() {
      _likes = profile['likes'];
      _plays = profile['plays'];
    });

    return profile;
  }

  Future<void> fetchSongs(String authToken) async {
    final songs = await ArtistService.fetchSongs(authToken, artistId);

    setState(() {
      _songs = songs;
    });
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    final sourceKey = getSourceKey();
    if (!audioPlayer.isSourcedFrom(sourceKey)) {
      audioPlayer.loadPlaylistFromSource(sourceKey, _songs);
    }
    await audioPlayer.playOrPause(song);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LloudTheme.blackLight,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: HomeButton(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              backgroundColor: LloudTheme.black,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: FutureBuilder<Map<String, dynamic>>(
                  future: _artistProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) return Container();

                    return H1(snapshot.data['artist'].name,
                        color: LloudTheme.white);
                  },
                ),
                background: FutureBuilder<ImageFile>(
                  future: _profileImg,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting)
                      return ArtistProfileImage(img: ImageFile.empty());

                    return ArtistProfileImage(img: snapshot.data);
                  },
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LikesStat(Helpers.formatNumber(_likes)),
                    SizedBox(
                      width: 12,
                    ),
                    PlaysStat(Helpers.formatNumber(_plays))
                  ],
                ),
              ),
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 8),
                padding: EdgeInsets.symmetric(horizontal: 16),
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
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SongWidgetSmall(
                    song: _songs[index],
                    onPlay: handlePlay,
                  ),
                );
              }, childCount: _songs.length),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              FutureBuilder(
                  future: _supporters,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting)
                      return Container();

                    return Container(
                        margin: EdgeInsets.only(
                            top: 32, right: 16, bottom: 8, left: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 16),
                                child: H1('Top Supporters',
                                    color: LloudTheme.white),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: ArtistSupporterList(
                                      supporters: snapshot.data))
                            ]));
                  })
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              FutureBuilder<Map<String, dynamic>>(
                  future: _artistProfile,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting)
                      return Container();

                    final artist = snapshot.data['artist'];
                    return Container(
                      margin: EdgeInsets.only(top: 32, bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (artist.description != null)
                            H1(
                              'About',
                              color: LloudTheme.white,
                            ),
                          if (artist.city != null && artist.state != null)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '${artist.city}, ${artist.state}',
                                style: TextStyle(
                                    color: LloudTheme.white,
                                    height: 1.9,
                                    fontSize: 16),
                              ),
                            ),
                          if (artist.description != null)
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  artist.description,
                                  style: TextStyle(
                                      color: LloudTheme.white,
                                      height: 1.9,
                                      fontSize: 16),
                                )),
                          SizedBox(
                            height: 64,
                          )
                        ],
                      ),
                    );
                  })
            ]))
          ],
        ),
      ),
    );
  }

  String getSourceKey() {
    return 'artist:$artistId';
  }
}
