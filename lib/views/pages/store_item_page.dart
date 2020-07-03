import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/providers/points.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/store_item.dart';
import 'package:lloud_mobile/views/_common/cost_badge.dart';
import 'package:lloud_mobile/views/templates/backpage_template.dart';

class StoreItemPage extends StatefulWidget {
  @override
  _StoreItemPageState createState() => _StoreItemPageState();
}

class _StoreItemPageState extends State<StoreItemPage> {
  final GlobalKey<FormFieldState> _shirtSizeKey = GlobalKey<FormFieldState>();
  StoreItem _storeItem;
  bool _isPurchased = false;
  String _shirtSize;

  Future<void> _purchaseItem(BuildContext context) async {
    dynamic dal = DAL.instance();
    String shirtSize = (_shirtSizeKey.currentState == null)
        ? null
        : _shirtSizeKey.currentState.value;
    Response res = await dal.post('store-items/purchase',
        {'store_item_id': this._storeItem.id, 'size': shirtSize});

    Map<String, dynamic> decodedResponse = json.decode(res.body);

    if (!decodedResponse['success']) {
      Navigator.of(context).pop();
      _showPurchaseFailureDialog(context, decodedResponse['message']);
      return;
    }

    setState(() {
      _isPurchased = true;
    });

    Navigator.of(context).pop();
    _showPurchaseSuccessDialog(context);
  }

  void _showPurchaseFailureDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Oh No!"),
            content: Text("Something went wrong. Error Message: ${message}"),
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
            content: Text("Your ${this._storeItem.name} is on the way!!"),
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
    int remainingPoints = currentPoints - this._storeItem.cost;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Are you sure you want to purchase a ${this._storeItem.name}?"),
            content: Text(
                "You will have ${remainingPoints.toString()} points left after this purchase."),
            actions: <Widget>[
              RaisedButton(
                color: LloudTheme.red,
                child: Text("Yes, I want to purchase this item"),
                onPressed: () async {
                  await _purchaseItem(context);
                },
              ),
              FlatButton(
                child: Text("Cancel"),
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
                "Like more songs in order to earn points. You get a point when someone likes a song after you."),
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
                  Navigator.pushNamed(context, '/account');
                },
              ),
              FlatButton(
                child: Text("I'll Do It Later"),
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
    final points = Provider.of<Points>(context, listen: false).points;
    final user = Provider.of<UserModel>(context, listen: false).user;
    this._storeItem = ModalRoute.of(context).settings.arguments;

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
                        this._storeItem.name,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway'),
                      ),
                      Text(
                        this._storeItem.type,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: LloudTheme.red,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16.0),
                        child: CostBadge(
                            this._storeItem.cost, this._storeItem.qty),
                      )
                    ],
                  )),
            ],
          )),
      SizedBox(height: 16.0),
      AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.network(this._storeItem.imageUrl, fit: BoxFit.cover)),
      SizedBox(height: 16.0),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          this._storeItem.description,
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: this._storeItem.sizes.isEmpty
            ? null
            : Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                          validator: (String value) {
                            return (value == null)
                                ? 'Please select a ${this._storeItem.type} size.'
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
                          items: this._storeItem.getSizes().map((String size) {
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
                      if (this._storeItem.qty <= 0) {
                        return _showSoldOutDialog(context);
                      }

                      if (points < this._storeItem.cost) {
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
