import 'dart:convert';
import 'package:flutter/material.dart';

import '../../util/dal.dart';

class RemainingLikes extends StatefulWidget {
  @override
  _RemainingLikesState createState() => _RemainingLikesState();
}

class _RemainingLikesState extends State<RemainingLikes> {
  Future<Text> _futureTxtLikesBalance;

  Future<Text> fetchTxtLikesBalance() async {
    final response = await DAL.instance().fetch('user/likes');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    var items = jsonObj['items'][0];

    return Text(
        items['balance'].toString() + '/' + items['weeklyAllowance'].toString(),
        style: TextStyle(fontWeight: FontWeight.w300));
  }

  @override
  void initState() {
    super.initState();
    _futureTxtLikesBalance = fetchTxtLikesBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
          child: Icon(Icons.favorite),
        ),
        FutureBuilder<Text>(
          future: fetchTxtLikesBalance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              debugPrint('Error:');
              debugPrint("${snapshot.error}");
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        )
      ],
    );
  }
}
