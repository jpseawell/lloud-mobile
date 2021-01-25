import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/store_item.dart';
import 'package:lloud_mobile/views/components/cost_badge.dart';

class StoreItemWidget extends StatelessWidget {
  final StoreItem storeItem;

  StoreItemWidget(this.storeItem);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8, bottom: 32),
        child: InkWell(
          splashColor: LloudTheme.red.withAlpha(30),
          onTap: () {
            return Navigator.pushNamed(context, '/store-item',
                arguments: storeItem);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.zero,
                  child: AspectRatio(
                      aspectRatio: 5 / 4,
                      child: Image.network(
                          storeItem.imageUrl + '?tr=w-1200,h-1200'))),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(storeItem.name,
                            style: TextStyle(
                                color: LloudTheme.blackLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Text(
                          storeItem.type,
                          style: TextStyle(
                              color: LloudTheme.blackLight.withOpacity(.75),
                              fontSize: 20),
                        ),
                        SizedBox(height: 12),
                        CostBadge(storeItem)
                      ]))
            ],
          ),
        ));
  }
}
