import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/store_items.dart';
import 'package:lloud_mobile/views/components/h1.dart';
import 'package:lloud_mobile/views/components/store_item_widget.dart';

class StorePage extends StatefulWidget {
  final ScrollController scrollController;

  StorePage(this.scrollController);

  @override
  _StorePageState createState() => _StorePageState(this.scrollController);
}

class _StorePageState extends State<StorePage> {
  final ScrollController _scrollController;

  _StorePageState(this._scrollController);

  Future<void> _storeItems;

  @override
  void initState() {
    super.initState();
    _storeItems =
        Provider.of<StoreItems>(context, listen: false).fetchAndSetStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<StoreItems>(context).items;
    return Scaffold(
      backgroundColor: LloudTheme.white2,
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            H1('Shop'),
            SizedBox(height: 8.0),
            FutureBuilder(
                future: _storeItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(LloudTheme.red)),
                    );

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var item in items) StoreItemWidget(item)
                      ]);
                })
          ],
        ),
      ),
    );
  }
}
