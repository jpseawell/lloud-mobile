import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/account.dart';
import 'package:lloud_mobile/providers/account.dart';

class AccountBalancesBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Account acct = Provider.of<AccountProvider>(context).account;

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Card(
                    child: Container(
                      height: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            acct.pointsBalance.toString(),
                            style: TextStyle(
                                color: (acct.pointsBalance == 0)
                                    ? LloudTheme.black.withOpacity(.5)
                                    : LloudTheme.black,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Points')
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Card(
                    child: Container(
                      height: 72,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            acct.likesBalance.toString(),
                            style: TextStyle(
                                color: (acct.likesBalance == 0)
                                    ? LloudTheme.black.withOpacity(.5)
                                    : LloudTheme.black,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Likes Remaining')
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
