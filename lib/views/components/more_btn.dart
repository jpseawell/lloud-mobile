import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/util/network.dart';

class MoreButton extends StatelessWidget {
  final Song _song;
  final Color color;
  final String _appUrl = 'https://apps.apple.com/us/app/lloud/id1506399049';

  MoreButton(this._song, {this.color});

  Future<void> _reportSong(BuildContext context) async {
    final url = '${Network.host}/api/v2/offensive-report';
    final token = Provider.of<Auth>(context, listen: false).token;
    await http.post(url,
        headers: Network.headers(token: token),
        body: json.encode({'song_id': _song.id}));
  }

  void _showReportConfirmedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thanks for letting us know"),
            content: Text(
                "Your feedback is important in helping us keep the Lloud community safe."),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              )
            ],
          );
        });
  }

  void _showSongMenuDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      "Report as Offensive",
                      style: TextStyle(fontSize: 16),
                    ),
                    textColor: LloudTheme.red,
                    onPressed: () async {
                      await _reportSong(context);
                      Navigator.of(context).pop();
                      _showReportConfirmedDialog(context);
                    },
                  )),
                ]),
                Divider(
                  height: 1,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      "Share",
                      style: TextStyle(fontSize: 16),
                    ),
                    textColor: LloudTheme.black,
                    onPressed: () async {
                      Share.share(
                          'Go checkout the song ${_song.title} by ${_song.artistName} on Lloud:\n$_appUrl',
                          subject:
                              'Checkout ${_song.title} by ${_song.artistName} on Lloud!');
                      Navigator.of(context).pop();
                    },
                  )),
                ]),
                Divider(
                  height: 1,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                      textColor: LloudTheme.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 24,
      minWidth: 8,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: FlatButton(
          onPressed: () {
            _showSongMenuDialog(context);
          },
          child: Icon(
            Icons.more_horiz,
            color: color ?? LloudTheme.white,
          )),
    );
  }
}
