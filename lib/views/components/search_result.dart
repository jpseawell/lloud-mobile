import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/dal.dart';
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
                  child: Image.network(
                    imgLocation + '?tr=w-75,h-75',
                    fit: BoxFit.fill,
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

  // TODO: DRY this up with the one in showcase.dart
  Future<void> loadSongAndOpenPlayer(BuildContext context, int songId) async {
    final response = await DAL.instance().fetch('songs/$songId');
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    Song song = Song.fromJson(decodedResponse["data"]["song"]);

    AudioProvider ap = Provider.of<AudioProvider>(context, listen: false);

    ap.setPlaylist('song:${song.id}', [song]);
    ap.findAndPlay(0);
    Navigator.pushNamed(context, Routes.audio_player);
  }

  Widget song(BuildContext context) {
    return InkWell(
      onTap: () async {
        await loadSongAndOpenPlayer(context, subjectId);
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
