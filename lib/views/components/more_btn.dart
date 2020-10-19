import 'package:flutter/material.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class MoreButton extends StatelessWidget {
  final Song _song;
  final Color color;

  MoreButton(this._song, {this.color});

  Future<void> _reportSong() async {
    await DAL.instance().post('offensive-report', {'song_id': _song.id});
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
          // TODO: Replace with LloudDialog
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
                      await _reportSong();
                      Navigator.of(context).pop();
                      _showReportConfirmedDialog(context);
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
