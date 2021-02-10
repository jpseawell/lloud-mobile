import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/views/components/h2.dart';
import 'package:lloud_mobile/views/components/user_avatar.dart';

class SearchResult extends StatelessWidget {
  final int type;
  final int subjectId;
  final String imgLocation;
  final String title;
  final String description;

  SearchResult(
      {this.type,
      this.subjectId,
      this.imgLocation,
      this.title,
      this.description});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 1:
        return artist(context);
        break;
      case 2:
        return user(context);
        break;
      case 3:
        return song(context);
        break;
      default:
        return Container();
    }
  }

  Widget artist(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.artist, arguments: subjectId);
      },
      child: Container(
        height: 88,
        padding: EdgeInsets.all(8),
        color: LloudTheme.white,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 8),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: imgLocation.isNotEmpty
                      ? Image.network(
                          imgLocation + '?tr=w-75,h-75',
                          fit: BoxFit.fill,
                        )
                      : Container(),
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H2(title),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _handleSongNameTap(BuildContext context, int songId) async {
    final url = '${Network.host}/api/v2/songs/$songId';
    final token = Provider.of<Auth>(context, listen: false).token;
    final res = await http.get(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    Song song = Song.fromJson(decodedRes["data"]["song"]);

    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    final sourceKey = 'song:${song.id}';
    if (!audioPlayer.isSourcedFrom(sourceKey)) {
      audioPlayer.loadPlaylistFromSource(sourceKey, [song]);
    }
    await audioPlayer.playOrPause(song);

    Navigator.pushNamed(context, Routes.audio_player);
  }

  Widget song(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _handleSongNameTap(context, subjectId);
      },
      child: Container(
        height: 88,
        padding: EdgeInsets.all(8),
        color: LloudTheme.white,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 8),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        imgLocation + '?tr=w-75,h-75',
                        fit: BoxFit.fill,
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            'assets/play.svg',
                            color: LloudTheme.white.withOpacity(.85),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H2(title),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget user(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.profile, arguments: subjectId);
      },
      child: Container(
        height: 88,
        padding: EdgeInsets.all(8),
        color: LloudTheme.white,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: UserAvatar(
                key: UniqueKey(),
                radius: 32,
                userId: subjectId,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H2(title),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
