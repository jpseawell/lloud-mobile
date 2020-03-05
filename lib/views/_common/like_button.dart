import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import '../../util/dal.dart';
import '../../providers/likes.dart';

class LikeButton extends StatefulWidget {
  final int _songId;
  final int _likesForThisSong;
  bool _likedByUser;

  LikeButton(this._songId, this._likesForThisSong, this._likedByUser);

  @override
  _LikeButtonState createState() =>
      _LikeButtonState(this._songId, this._likesForThisSong, this._likedByUser);
}

class _LikeButtonState extends State<LikeButton> {
  final int _songId;
  int _likesForThisSong;
  bool _likedByUser;

  _LikeButtonState(this._songId, this._likesForThisSong, this._likedByUser);

  Future<void> _likeSong(BuildContext ctx) async {
    if (_likedByUser) {
      return;
    }

    final response = await DAL
        .instance()
        .post('song/' + this._songId.toString() + '/like', {});

    if (response.statusCode == 201) {
      setState(() {
        _likedByUser = true;
        _likesForThisSong = _likesForThisSong + 1;
      });

      Provider.of<Likes>(ctx, listen: false).fetchLikes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      textColor: LloudTheme.white,
      color: LloudTheme.red,
      onPressed: () async => await _likeSong(context),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(_likedByUser ? Icons.favorite : Icons.favorite_border),
          ),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_likesForThisSong.toString(),
                      style: TextStyle(fontSize: 20))
                ],
              ))
        ],
      ),
    );
  }
}
