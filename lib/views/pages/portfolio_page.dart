import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:lloud_mobile/views/_common/portfolio_item_widget.dart';

import '../../util/dal.dart';
import '../../models/portfolio_item.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  Future<List<PortfolioItem>> _portfolioItems;

  Future<List<PortfolioItem>> fetchPortfolioItems() async {
    final response = await DAL.instance().fetch('user/portfolio');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    List<dynamic> rawPortfolioItems = jsonObj['items'][0][0]['songReports'];

    List<PortfolioItem> portfolioItems = [];
    rawPortfolioItems.forEach((portfolioItem) =>
        portfolioItems.add(PortfolioItem.fromJson(portfolioItem)));
    return portfolioItems;
  }

  PortfolioItemWidget buildPortfolioItem(BuildContext ctx, int index) {}

  @override
  void initState() {
    super.initState();
    _portfolioItems = fetchPortfolioItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          FutureBuilder<List<PortfolioItem>>(
            future: _portfolioItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PortfolioItemWidget> pItemWidgets = [];
                snapshot.data.forEach(
                    (item) => pItemWidgets.add(new PortfolioItemWidget(item)));

                int pointsSum = 0;
                snapshot.data.forEach((item) => pointsSum += item.points);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            H1("Portfolio"),
                            Text(
                                "You've liked ${snapshot.data.length} songs and earned a total of ${pointsSum} points!",
                                style: TextStyle(fontSize: 21)),
                          ],
                        )),
                    SizedBox(height: 8.0),
                    Column(
                      children: pItemWidgets,
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                debugPrint("${snapshot.error}");
                return Text('');
              }

              return new Text(''); // Loading bar
            },
          )
        ],
      )),
    );
  }
}
