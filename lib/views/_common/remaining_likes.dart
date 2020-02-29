import 'package:flutter/material.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
          child: Icon(Icons.favorite),
        ),
        Text('${likes.remaining} / ${likes.allowance}',
            style: TextStyle(fontWeight: FontWeight.w300))
      ],
    );
  }
}
