import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/models/artist.dart';
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

  Artist _artist;
  ImageFile _profileImg = ImageFile.empty();
  List<Song> _songs = [];
  List<dynamic> _supporters = [];
  int _likes = 0, _plays = 0;

  _ArtistPageState(this.artistId);

  @override
  void initState() {
    super.initState();
    final authToken = Provider.of<Auth>(context, listen: false).token;
    _fetchAndSetArtist(artistId, authToken);
    _fetchAndSetSongs(artistId, authToken);
    _fetchAndSetImage(artistId, authToken);
    _fetchAndSetSupporters(artistId, authToken);
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    final sourceKey = getSourceKey();
    if (!audioPlayer.isSourcedFrom(sourceKey)) {
      audioPlayer.setPlaylistFromNewSource(sourceKey, _songs);
    }
    await audioPlayer.togglePlay(song);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LloudTheme.blackLight,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: HomeButton(),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              backgroundColor: LloudTheme.black,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: _artist != null
                    ? H1(_artist.name, color: LloudTheme.white)
                    : Container(),
                background: ArtistProfileImage(img: _profileImg),
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
              if (_supporters.length > 0)
                Container(
                  margin: EdgeInsets.only(top: 32, bottom: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ArtistSupporterList(supporters: _supporters),
              )
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              if (_artist != null)
                Container(
                  margin: EdgeInsets.only(top: 32, bottom: 8),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_artist.description != null)
                        H1(
                          'About',
                          color: LloudTheme.white,
                        ),
                      if (_artist.city != null && _artist.state != null)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${_artist.city}, ${_artist.state}',
                            style: TextStyle(
                                color: LloudTheme.white,
                                height: 1.9,
                                fontSize: 16),
                          ),
                        ),
                      if (_artist.description != null)
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              _artist.description,
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
                )
            ]))
          ],
        ),
      ),
    );
  }

  String getSourceKey() {
    return 'artist:$artistId';
  }

  Future<void> _fetchAndSetArtist(int artistId, String authToken) async {
    final url = '${Network.host}/api/v2/artists/$artistId';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Unable to retrieve artist');

    setState(() {
      _artist = Artist.fromJson(decodedRes["data"]["artist"]);
      _likes = decodedRes['data']['likes'];
      _plays = decodedRes['data']['plays'];
    });
  }

  Future<void> _fetchAndSetImage(int artistId, String authToken) async {
    final url = '${Network.host}/api/v2/artist/$artistId/image-files';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    setState(() {
      _profileImg = ImageFile.fromJson(decodedRes['data']['imageFile']);
    });
  }

  Future<void> _fetchAndSetSongs(int artistId, String authToken) async {
    final url = '${Network.host}/api/v2/artist/$artistId/songs';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['data'] != null)
      setState(() {
        _songs = Song.fromJsonList(decodedRes['data']['songs']);
      });
  }

  Future<void> _fetchAndSetSupporters(int artistId, String authToken) async {
    final url = '${Network.host}/api/v2/artist/$artistId/supporters';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    _supporters = decodedRes['data']['supporters'];
  }
}
