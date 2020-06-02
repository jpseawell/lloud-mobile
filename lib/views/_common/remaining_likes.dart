import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/likes.dart';

class RemainingLikes extends StatefulWidget {
  @override
  _RemainingLikesState createState() => _RemainingLikesState();
}

class _RemainingLikesState extends State<RemainingLikes> {
  @override
  Widget build(BuildContext context) {
    final likes = Provider.of<Likes>(context);
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
        onPressed: () {
          // TODO: Don't show sub page if already subscribed
          Navigator.pushNamed(context, '/subscription');
        },
        textColor: LloudTheme.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Icon(
                Icons.favorite,
                size: 22,
              ),
            ),
            // Text('${likes.remaining} / ${likes.allowance}',
            //     style: TextStyle(fontWeight: FontWeight.w300))
          ],
        ));
  }
}
