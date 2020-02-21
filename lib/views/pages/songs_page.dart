import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/song.dart';
import '../../util/dal.dart';

import '../_common/h1.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  Future<List<Song>> songs;

  // Future<List<Song>>
  Future<void> fetchSongs() async {
    final response = await DAL.instance().fetch('song/page/1');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    var rawSongs = jsonObj['items'][0];
    debugPrint(rawSongs[0].toString());

    // if (response.statusCode == 200) {

    // rawSongs.forEach((song) => {
    //   // TODO: Build a list of songs
    // });
    // } else {
    //   throw Exception('Failed to load album');
    // }
  }

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ListView(
          children: <Widget>[H1('Songs Page!!!')],
        ),
      )),
    );
  }
}
