import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/providers/likes.dart';

class LikeButton extends StatefulWidget {
  final int _songId;
  bool _likedByUser;

  LikeButton(this._songId, this._likedByUser);

  @override
  _LikeButtonState createState() =>
      _LikeButtonState(this._songId, this._likedByUser);
}

class _LikeButtonState extends State<LikeButton> {
  final int _songId;
  bool _likedByUser;

  _LikeButtonState(this._songId, this._likedByUser);

  void _showAlreadyLikedDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("You've already liked this song."),
            content: new Text("You can only like each song one time."),
            actions: <Widget>[
              new FlatButton(
                textColor: LloudTheme.black,
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _songLikedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(28, 28, 28, 0.5),
            title: Icon(
              Icons.favorite,
              size: 64,
              color: LloudTheme.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              "Added to portfolio.",
              textAlign: TextAlign.center,
            ),
            contentTextStyle: TextStyle(color: LloudTheme.white),
          );
        });

    Timer timer = new Timer(new Duration(milliseconds: 1000), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> _likeSong(BuildContext ctx) async {
    if (_likedByUser) {
      return;
    }

    final response = await DAL
        .instance()
        .post('songs/' + this._songId.toString() + '/like', {});

    print('TEST');
    print(response.body.toString());

    if (response.statusCode == 201) {
      setState(() {
        _likedByUser = true;
      });

      _songLikedDialog(ctx);

      Provider.of<Likes>(ctx, listen: false).fetchLikes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      constraints: BoxConstraints(maxWidth: 56.0),
      child: RaisedButton(
        onPressed: () async {
          if (Provider.of<Likes>(context, listen: false).remaining <= 0) {
            // Navigator.pushNamed(context, '/subscription');
          }

          if (_likedByUser) {
            await _showAlreadyLikedDialog(context);
            return;
          }

          await _likeSong(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              color: LloudTheme.red,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 64, 64, 1.0),
                  Color.fromRGBO(239, 62, 62, 1.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4.0)),
          child: Container(
            alignment: Alignment.center,
            child: ShadowIcon(
                _likedByUser ? Icons.favorite : Icons.favorite_border),
          ),
        ),
      ),
    );
  }
}

class ShadowIcon extends StatelessWidget {
  final IconData _icon;

  ShadowIcon(this._icon);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 1.0,
          top: 2.0,
          child: Icon(_icon, color: Color.fromRGBO(28, 28, 28, .25)),
        ),
        Icon(_icon, color: LloudTheme.white),
      ],
    );
  }
}
