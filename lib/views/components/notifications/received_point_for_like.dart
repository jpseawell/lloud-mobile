import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/views/components/empty_avatar.dart';
import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/notification.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/routes.dart';

class ReceivedPointForLike extends StatefulWidget {
  final Notification notification;

  ReceivedPointForLike({this.notification});

  @override
  _ReceivedPointForLikeState createState() =>
      _ReceivedPointForLikeState(notification: this.notification);
}

class _ReceivedPointForLikeState extends State<ReceivedPointForLike> {
  final Notification notification;
  dynamic _user;
  dynamic _artist;
  dynamic _song;
  TapGestureRecognizer _usernameTapRecognizer;
  TapGestureRecognizer _artistNameTapRecognizer;
  TapGestureRecognizer _songNameTapRecognizer;

  _ReceivedPointForLikeState({this.notification});

  @override
  void initState() {
    super.initState();
    _user = notification.subjects.first.subject;
    _song = notification.subjects.elementAt(1).subject;
    _artist = notification.subjects.elementAt(2).subject;

    _usernameTapRecognizer = TapGestureRecognizer()..onTap = _handleUserNameTap;
    _artistNameTapRecognizer = TapGestureRecognizer()
      ..onTap = _handleArtistNameTap;
    _songNameTapRecognizer = TapGestureRecognizer()..onTap = _handleSongNameTap;
  }

  void _handleUserNameTap() {
    Navigator.of(context).pushNamed(Routes.profile, arguments: _user["id"]);
  }

  void _handleArtistNameTap() {
    Navigator.of(context).pushNamed(Routes.artist, arguments: _artist["id"]);
  }

  Future<void> _handleSongNameTap() async {
    final url = '${Network.host}/api/v2/songs/${_song["id"]}';
    final token = Provider.of<Auth>(context, listen: false).token;
    final res = await http.get(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Error: Song retrieval failed.');

    Song song = Song.fromJson(decodedRes["data"]["song"]);

    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    final sourceKey = 'song:${song.id}';
    if (!audioPlayer.isSourcedFrom(sourceKey)) {
      audioPlayer.loadPlaylistFromSource(sourceKey, [song]);
    }
    await audioPlayer.playOrPause(song);

    Navigator.pushNamed(context, Routes.audio_player);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 4, right: 4),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.profile,
                                arguments: _user["id"]);
                          },
                          child: (_user['profileImg'] == null)
                              ? EmptyAvatar(
                                  isDark: true,
                                  radius: 20,
                                  initial: _user['username'].substring(0, 1),
                                )
                              : CircleAvatar(
                                  backgroundColor: LloudTheme.blackLight,
                                  backgroundImage: NetworkImage(
                                      _user['profileImg']['location'] +
                                          '?tr=w-50,h-50')),
                        ),
                      )
                    ],
                  ),
                  Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: RichText(
                                text: TextSpan(
                                    recognizer: _usernameTapRecognizer,
                                    text: '@' + _user['username'],
                                    style: TextStyle(
                                        height: 1.5,
                                        color: LloudTheme.blackLight,
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                  TextSpan(
                                      text: ' gave you a point for liking ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      recognizer: _songNameTapRecognizer,
                                      text: _song['title'],
                                      style: TextStyle(fontSize: 14)),
                                  TextSpan(
                                      text: ' by ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      recognizer: _artistNameTapRecognizer,
                                      text: _artist['name'],
                                      style: TextStyle(fontSize: 14)),
                                  TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: ' ${notification.createdAtFromNow}',
                                      style: TextStyle(
                                          color: LloudTheme.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300)),
                                ])),
                          )
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await _handleSongNameTap();
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Card(
                                  color: LloudTheme.blackLight,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                _song['imageFile']['location'] +
                                                    '?tr=w-50,h-50'),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
              tileColor: (notification.seenAt == null)
                  ? LloudTheme.red.withOpacity(.10)
                  : LloudTheme.white,
            ),
            Divider(
              height: 1,
              color: LloudTheme.blackLight.withOpacity(.25),
            )
          ],
        ))
      ],
    );
  }
}
