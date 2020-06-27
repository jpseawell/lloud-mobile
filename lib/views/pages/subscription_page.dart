import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/util/purchase_handler.dart';

import 'package:lloud_mobile/views/_common/h1.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool success = false;

  @override
  void initState() {
    try {
      PurchaseHandler.listen(_handlePurchase);
    } catch (err) {
      return _redirectToErrorPage();
    }
    super.initState();
  }

  @override
  void dispose() {
    PurchaseHandler.stopListening();
    super.dispose();
  }

  void _redirectToErrorPage() {
    PurchaseHandler.stopListening();
    Future(() {
      Navigator.pushNamedAndRemoveUntil(
          context, '/subscription-error', ModalRoute.withName('/'));
    });
  }

  void _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // TODO: Update w spinner
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        return _redirectToErrorPage();
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await PurchaseHandler.verify(purchaseDetails);
        if (!valid) {
          return _redirectToErrorPage();
        }

        try {
          await PurchaseHandler.deliverProduct(purchaseDetails);
        } catch (err) {
          return _redirectToErrorPage();
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        PurchaseHandler.complete(purchaseDetails);
        setState(() {
          success = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: (success) ? SubscriptionSuccess() : SubscriptionPurchase(),
    ));
  }
}

class SubscriptionPurchase extends StatelessWidget {
  void _showAlreadyPurchasedDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("You're already a Lloud subscriber."),
            content: new Text(
                "Check back later! We're working on new ways to get you more likes."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 36.0),
      children: <Widget>[
        SizedBox(height: 200.0),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          H1('Get More Likes'),
          SizedBox(height: 20.0),
          Text(
              'A Lloud monthly subscription provides you with 20 likes per month. Likes can bring you points, and points may be redeemed for exclusive merch from the Lloud store.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5)),
          SizedBox(height: 80.0),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    onPressed: () async {
                      // TODO: Calculate whether user is an active subscriber or not
                      if (PurchaseHandler.hasPurchased('like_refill.20mo')) {
                        return _showAlreadyPurchasedDialog(context);
                      }
                      PurchaseHandler.buySubscription();
                    },
                    color: LloudTheme.red,
                    textColor: LloudTheme.white,
                    child: Text(
                      'Subscribe Now - \$9.99/mo',
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    textColor: LloudTheme.red,
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
            ],
          ),
        ]),
      ],
    );
  }
}

class SubscriptionSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 36.0),
      children: <Widget>[
        SizedBox(height: 200.0),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          H1('Congrats!'),
          SizedBox(height: 20.0),
          Text(
              'Your likes have been replenished. You will now receive weekly like refills for the remainder of your subscription.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5)),
          SizedBox(height: 80.0),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/nav');
                    },
                    color: LloudTheme.red,
                    textColor: LloudTheme.white,
                    child: Text(
                      "Go like some songs!",
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
            ],
          ),
        ]),
      ],
    );
  }
}
