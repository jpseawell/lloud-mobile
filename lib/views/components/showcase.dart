import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/showcase_item.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/h1.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/components/showcase_tile.dart';
import 'package:provider/provider.dart';

class Showcase extends StatefulWidget {
  @override
  _ShowcaseState createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  Future<List<ShowcaseItem>> showcaseItems;

  @override
  void initState() {
    super.initState();
    showcaseItems = fetchShowcaseItems();
  }

  Future<List<ShowcaseItem>> fetchShowcaseItems() async {
    final res = await DAL.instance().fetch('showcase-items');
    Map<String, dynamic> decodedRes = json.decode(res.body);

    return ShowcaseItem.fromJsonList(decodedRes["data"]["showcaseItems"]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShowcaseItem>>(
        future: showcaseItems,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          }

          List<ShowcaseItem> items = snapshot.data;

          return Column(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: primary(items),
                    ))
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                children: tileRow(items.sublist(3, 7)),
              )),
              Expanded(
                  child: Row(
                children: tileRow(items.sublist(7, 11)),
              )),
            ],
          );
        });
  }

  List<Widget> tileRow(List<ShowcaseItem> items) {
    List<Widget> row = [];
    items.forEach((item) {
      row.add(
        Expanded(
            flex: 1,
            child: ShowcaseTile(
              item: item,
            )),
      );
    });
    return row;
  }

  Widget primary(List<ShowcaseItem> items) {
    return CarouselSlider(
      options: CarouselOptions(
          initialPage: 0,
          aspectRatio: 3 / 2,
          viewportFraction: 1,
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          autoPlayInterval: Duration(seconds: 12),
          autoPlay: true),
      items: items.sublist(0, 3).map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(i.subject['imageFile']
                                      ['location'] +
                                  '?tr=w-300,h-300'),
                              fit: BoxFit.cover)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(),
                      ),
                    ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withOpacity(.05),
                            Colors.black.withOpacity(.25),
                            Colors.black.withOpacity(.75)
                          ],
                        ),
                      ),
                      child: Container(),
                    ))
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      child: getContent(context, i),
                    )
                  ],
                )
              ],
            );
          },
        );
      }).toList(),
    );
  }

  String artistInfo(ShowcaseItem item) {
    if (item.subject['city'] == null || item.subject['state'] == null) {
      return '${item.subject['likes']} likes';
    }

    return '${item.subject['likes']} likes | ${item.subject['city']}, ${item.subject['state']}';
  }

  Widget getContent(BuildContext context, ShowcaseItem item) {
    switch (item.entityTypeId) {
      case 1:
        return primaryArtist(item);
        break;
      case 3:
        return primarySong(context, item);
        break;
      default:
        return Container();
    }
  }

  Widget primaryArtist(ShowcaseItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.subject['name'],
          style: TextStyle(
              shadows: [
                Shadow(
                    color: LloudTheme.black.withOpacity(.5),
                    blurRadius: 8,
                    offset: Offset(0, 2))
              ],
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
              color: LloudTheme.white),
        ),
        Text(
          artistInfo(item),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: LloudTheme.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: RaisedButton(
              padding: EdgeInsets.zero,
              color: LloudTheme.red,
              textColor: LloudTheme.white,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(Routes.artist, arguments: item.subject['id']);
              },
              child: Text(
                'Go Listen',
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: LloudTheme.black.withOpacity(.75),
                        blurRadius: 4,
                        offset: Offset(0, 1))
                  ],
                ),
              )),
        )
      ],
    );
  }

  Widget primarySong(BuildContext context, ShowcaseItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.subject['title'],
          style: TextStyle(
              shadows: [
                Shadow(
                    color: LloudTheme.black.withOpacity(.5),
                    blurRadius: 8,
                    offset: Offset(0, 1))
              ],
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
              color: LloudTheme.white),
        ),
        Text(
          '${item.subject['__meta__']['likes_count']} likes | ${item.subject['__meta__']['likes_count']} plays',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: LloudTheme.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: RaisedButton(
              padding: EdgeInsets.zero,
              color: LloudTheme.red,
              textColor: LloudTheme.white,
              onPressed: () async {
                await loadSongAndOpenPlayer(context, item.subject['id']);
              },
              child: Text(
                'Listen Now',
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: LloudTheme.black.withOpacity(.75),
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
                ),
              )),
        )
      ],
    );
  }

  Future<void> loadSongAndOpenPlayer(BuildContext context, int songId) async {
    final response = await DAL.instance().fetch('songs/$songId');
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    Song song = Song.fromJson(decodedResponse["data"]["song"]);

    AudioProvider ap = Provider.of<AudioProvider>(context, listen: false);

    await ap.setPlaylist('song:${song.id}', [song]);
    ap.findAndPlay(0);
    Navigator.pushNamed(context, Routes.audio_player);
  }
}
