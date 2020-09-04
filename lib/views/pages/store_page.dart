import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/models/store_item.dart';
// import 'package:lloud_mobile/views/_common/h1.dart';
// import 'package:lloud_mobile/views/_common/store_item_widget.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Future<List<StoreItem>> _storeItems;

  Future<List<StoreItem>> fetchStoreItems() async {
    final response = await DAL.instance().fetch('store-items');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    List<StoreItem> storeItems = [];

    try {
      decodedResponse['data'].forEach(
          (storeItem) => storeItems.add(StoreItem.fromJson(storeItem)));
    } catch (err) {}

    return storeItems;
  }

  @override
  void initState() {
    super.initState();
    _storeItems = fetchStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            // H1('Store'),
            SizedBox(height: 8.0),
            FutureBuilder<List<StoreItem>>(
                future: _storeItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // List<StoreItemWidget> storeItemWidgets = [];
                    // snapshot.data.forEach((item) =>
                    //     storeItemWidgets.add(new StoreItemWidget(item)));
                    return Text('test');
                    // return Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: storeItemWidgets);
                  }

                  return CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(LloudTheme.red));
                })
          ],
        ),
      ),
    );
  }
}
