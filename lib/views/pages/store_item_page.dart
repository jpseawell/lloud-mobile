import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/store_items.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/store_item.dart';
import 'package:lloud_mobile/views/components/cost_badge.dart';
import 'package:lloud_mobile/views/templates/backpage_template.dart';

class StoreItemPage extends StatefulWidget {
  final StoreItem storeItem;

  StoreItemPage(this.storeItem);

  @override
  _StoreItemPageState createState() => _StoreItemPageState(this.storeItem);
}

class _StoreItemPageState extends State<StoreItemPage> {
  final StoreItem storeItem;
  final GlobalKey<FormFieldState> _shirtSizeKey = GlobalKey<FormFieldState>();
  String _shirtSize;

  _StoreItemPageState(this.storeItem);

  Future<void> _purchaseItem(BuildContext context) async {
    String shirtSize = (_shirtSizeKey.currentState == null)
        ? null
        : _shirtSizeKey.currentState.value;

    try {
      Provider.of<StoreItems>(context, listen: false)
          .purchaseItem({'store_item_id': storeItem.id, 'size': shirtSize});
    } catch (e) {
      Navigator.of(context).pop();
      _showPurchaseFailureDialog(context);
      return;
    }

    Navigator.of(context).pop();
    _showPurchaseSuccessDialog(context);
  }

  void _showPurchaseFailureDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Oh No!"),
            content: Text(
                "The store item could not be purchased at this time. Please try again later."),
            actions: <Widget>[
              RaisedButton(
                color: LloudTheme.red,
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showPurchaseSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Congratulations!"),
            content: Text("Your ${this.storeItem.name} is on the way!!"),
            actions: <Widget>[
              RaisedButton(
                color: LloudTheme.red,
                child: Text("Cool!"),
                onPressed: () async {
                  Navigator.pushNamed(context, '/store');
                },
              ),
            ],
          );
        });
  }

  void _confirmPurchase(BuildContext context, int currentPoints) {
    int remainingPoints = currentPoints - this.storeItem.cost;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Are you sure you want to purchase a ${this.storeItem.name}?"),
            content: Text(
                "You will have $remainingPoints points left after this purchase."),
            actions: <Widget>[
              RaisedButton(
                color: LloudTheme.red,
                child: Text("Yes, I want to purchase this item"),
                onPressed: () async {
                  await _purchaseItem(context);
                },
              ),
              FlatButton(
                child:
                    Text("Cancel", style: TextStyle(color: LloudTheme.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showNotEnoughPointsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You don't have enough points!"),
            content: Text(
                "Like more songs in order to earn points.\n\nYou get a point when someone likes a song after you."),
            actions: <Widget>[
              FlatButton(
                color: LloudTheme.red,
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showSoldOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("This Item is Sold Out."),
            content: Text("Check back later when we have more in stock."),
            actions: <Widget>[
              FlatButton(
                color: LloudTheme.red,
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showIncompleteAddressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("We don't have your address!"),
            content: Text(
                "Please provide your address so we can ship this item to you."),
            actions: <Widget>[
              RaisedButton(
                color: LloudTheme.red,
                child: Text("Go Enter My Address"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, Routes.shipping_info);
                },
              ),
              FlatButton(
                child: Text("I'll Do It Later",
                    style: TextStyle(color: LloudTheme.black)),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context, listen: false);
    final points = authProvider.account.pointsBalance;
    final user = authProvider.user;

    return BackpageTemplate(<Widget>[
      Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        this.storeItem.type,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 4),
                      Text(
                        this.storeItem.name,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 12),
                      CostBadge(storeItem)
                    ],
                  )),
            ],
          )),
      SizedBox(height: 16.0),
      AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.network(this.storeItem.imageUrl + '?tr=w-1200,h-1200',
              fit: BoxFit.cover)),
      SizedBox(height: 16.0),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          this.storeItem.description,
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: this.storeItem.sizes.isEmpty
            ? null
            : Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                          validator: (String value) {
                            return (value == null)
                                ? 'Please select a ${this.storeItem.type} size.'
                                : null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Choose A Shirt Size',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          key: _shirtSizeKey,
                          value: _shirtSize,
                          isExpanded: true,
                          style: TextStyle(fontSize: 22),
                          items: this.storeItem.getSizes().map((String size) {
                            return DropdownMenuItem<String>(
                                value: size,
                                child: Text(
                                  size,
                                  style: TextStyle(color: LloudTheme.black),
                                ));
                          }).toList(),
                          onChanged: (String size) {
                            setState(() {
                              _shirtSize = size;
                            });
                          }))
                ],
              ),
      ),
      Container(
        margin: EdgeInsets.symmetric(vertical: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: RaisedButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    color: LloudTheme.red,
                    textColor: LloudTheme.white,
                    onPressed: () {
                      if (this.storeItem.qty <= 0) {
                        return _showSoldOutDialog(context);
                      }

                      if (points < this.storeItem.cost) {
                        return _showNotEnoughPointsDialog(context);
                      }

                      if (!user.addressComplete()) {
                        return _showIncompleteAddressDialog(context);
                      }

                      if (_shirtSizeKey.currentState == null) {
                        return _confirmPurchase(context, points);
                      }

                      if (!_shirtSizeKey.currentState.validate()) {
                        return;
                      }

                      _confirmPurchase(context, points);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_shopping_cart),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Purchase Item',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )))
          ],
        ),
      ),
    ]);
  }
}
