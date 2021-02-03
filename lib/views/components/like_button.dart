import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/likes.dart';

class LikeButton extends StatefulWidget {
  final double area;

  final int songId;

  const LikeButton({
    Key key,
    @required this.songId,
    this.area = 56,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState(songId: songId);
}

class _LikeButtonState extends State<LikeButton> {
  final double area;
  final int songId;

  _LikeButtonState({@required this.songId, this.area = 56});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final songIds = Provider.of<Likes>(context).likedSongIds;
    final likedByUser = songIds.contains(songId);

    return Container(
        width: area,
        height: area,
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
            onTap: () async => await handleLike(likedByUser),
            child: Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: icon(likedByUser),
            ),
          ),
        ));
  }

  Widget icon(bool likedByUser) {
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

  Future<void> handleLike(bool isLikedByUser) async {
    HapticFeedback.heavyImpact();

    if (isLikedByUser) {
      _showAlreadyLikedDialog(context);
      return;
    }

    final authProvider = Provider.of<Auth>(context, listen: false);
    if (authProvider.account.likesBalance <= 0) {
      _showOutOfLikesDialog(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    final likesProvider = Provider.of<Likes>(context, listen: false);
    try {
      await likesProvider.addLike(songId);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
      _showLikeErrorDialog(context);
      setState(() {
        isLoading = false;
      });
      return;
    }

    await authProvider.fetchAndSetAccount(authProvider.token);

    _showSongLikedDialog(context);

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

  void _showOutOfLikesDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You're out of likes!"),
            content: Text("You can purchase more on your profile page."),
            actions: <Widget>[
              FlatButton(
                color: LloudTheme.red,
                child: Text("Buy More Likes!"),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.my_profile);
                },
              ),
              FlatButton(
                textColor: LloudTheme.black,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showSongLikedDialog(BuildContext context) {
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

  void _showLikeErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: LloudTheme.red.withOpacity(.75),
            title: Icon(
              Icons.error,
              size: 64,
              color: LloudTheme.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              "Error: Like was not successful.",
              textAlign: TextAlign.center,
            ),
            contentTextStyle: TextStyle(color: LloudTheme.white),
          );
        });

    Timer timer = new Timer(new Duration(milliseconds: 1000), () {
      Navigator.of(context).pop();
    });
  }
}
