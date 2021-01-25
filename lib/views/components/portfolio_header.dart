import 'package:flutter/material.dart';
import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/views/components/h2.dart';

class PortfolioHeader extends StatelessWidget {
  final List<PortfolioItem> items;
  final bool isMyProfile;

  PortfolioHeader(this.items, {this.isMyProfile = false});

  int _portfolioTotal() {
    var total = 0;
    for (var item in items) {
      total += item.points_earned;
    }
    return total;
  }

  String pronoun() {
    return isMyProfile ? 'You\'ve' : 'This user';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H2('Portfolio'),
          SizedBox(
            height: 4,
          ),
          Text(
            '${pronoun()} liked ${items.length} songs and earned a total of ${_portfolioTotal()} points!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
