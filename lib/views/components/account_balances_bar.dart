import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/account.dart';
import 'package:lloud_mobile/providers/auth.dart';

class AccountBalancesBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<Auth, Account>(
        selector: (context, auth) => auth.account,
        builder: (context, account, _) {
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
                                  account.pointsBalance.toString(),
                                  style: TextStyle(
                                      color: (account.pointsBalance == 0)
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
                                  account.likesBalance.toString(),
                                  style: TextStyle(
                                      color: (account.likesBalance == 0)
                                          ? LloudTheme.red.withOpacity(.85)
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
        });
  }
}
