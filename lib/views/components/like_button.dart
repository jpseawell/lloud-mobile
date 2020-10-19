import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/account.dart';
import 'package:lloud_mobile/util/dal.dart';

class LikeButton extends StatefulWidget {
  final double width;
  final double height;

  final int songId;
  final bool likedByUser;

  const LikeButton({
    Key key,
    @required this.songId,
    @required this.likedByUser,
    this.width = 56,
    this.height = 56,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState(
      songId: songId, likedByUser: likedByUser, width: width, height: height);
}

class _LikeButtonState extends State<LikeButton> {
  final double width;
  final double height;

  final int songId;
  bool likedByUser;
  bool isLoading = false;

  _LikeButtonState({
    @required this.songId,
    @required this.likedByUser,
    this.width = 56,
    this.height = 56,
  });

  Future<void> _likeSong(BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });

    final response = await DAL.instance().post('likes', {'song_id': songId});

    if (response.statusCode == 201) {
      _songLikedDialog(ctx);

      Provider.of<AccountProvider>(ctx, listen: false).fetchAndNotify();

      setState(() {
        likedByUser = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showAlreadyLikedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You've already liked this song."),
            content: Text("You can only like each song one time."),
            actions: <Widget>[
              FlatButton(
                textColor: LloudTheme.black,
                child: Text("Ok"),
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

  Widget icon() {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: Opacity(
            opacity: .75,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.white),
            ),
          ),
        ),
      );
    }

    return SvgPicture.asset(
      (likedByUser) ? 'assets/heart_full.svg' : 'assets/heart.svg',
      semanticsLabel: 'Heart Icon',
      width: 32,
      height: 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: LloudTheme.black.withOpacity(.25),
                offset: Offset(0.0, 2),
                blurRadius: 4,
              )
            ],
            gradient: LinearGradient(
              colors: [
                LloudTheme.red.withOpacity(1.0),
                LloudTheme.red.withOpacity(1.0),
                LloudTheme.red.withOpacity(.95)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: LloudTheme.red,
            onTap: () {
              /// TODO:
              /// - if no likes remaining: show 'buy likes alert'
              /// x if likedByUser: show already liked dialog
              /// x like song

              if (likedByUser) {
                _showAlreadyLikedDialog(context);
                return;
              }

              _likeSong(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: icon(),
            ),
          ),
        ));
  }
}
