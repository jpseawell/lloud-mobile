import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:lloud_mobile/providers/likes.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;
  bool _pendingPurchase = false;
  static String _rev_cat_api_key = 'XstlTtxLyLvhognmeAZyaVDIDSLQCFMy';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_rev_cat_api_key);
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    Offerings offerings = await Purchases.getOfferings();

    if (!mounted) return; // Avoid duplicates

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  Future<void> buySubscription(BuildContext context, Package package) async {
    setState(() {
      _pendingPurchase = true;
    });

    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      var newSubscriber = purchaserInfo.entitlements.all["Llouder"].isActive;
      if (newSubscriber) {
        final Response response =
            await DAL.instance().post('subscriptions/upgrade', {});
        if (response.statusCode != 200) {
          throw Exception("Subscription delivery failed");
        }

        Navigator.pushNamedAndRemoveUntil(
            context, '/subscription-success', ModalRoute.withName('/'));
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/subscription-error', ModalRoute.withName('/'));
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/subscription-error', ModalRoute.withName('/'));
      }
    } on Exception catch (e) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/subscription-error', ModalRoute.withName('/'));
    }

    setState(() {
      _pendingPurchase = false;
    });

    Navigator.pushNamedAndRemoveUntil(
        context, '/subscription-error', ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserModel>(context).user;

    List<Widget> stack = [];

    final likes = Provider.of<Likes>(context);
    bool _hasLikes = (likes.remaining > 0);

    if (_purchaserInfo == null || _pendingPurchase) {
      stack.add(LoadingScreen());
    } else {
      bool isSubscriber =
          _purchaserInfo.entitlements.all.containsKey('Llouder');
      if (isSubscriber) {
        stack.add(ListView(
          padding: EdgeInsets.symmetric(horizontal: 36.0),
          children: <Widget>[
            SizedBox(height: 200.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("You're Already A Subscriber.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway')),
                SizedBox(height: 24.0),
                Text(
                    "Still want more likes? We're constantly looking for new ways to reward you for having the best taste in music. Check back later!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5)),
                SizedBox(height: 40.0),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          color: LloudTheme.red,
                          textColor: LloudTheme.white,
                          child: Text(
                            'Go Back To Songs Page',
                            style: TextStyle(fontSize: 20),
                          ),
                        ))
                  ],
                ),
              ],
            )
          ],
        ));
      } else {
        if (_offerings != null) {
          final offering = _offerings.current;
          if (offering != null) {
            final monthly = offering.monthly;
            if (monthly != null) {
              stack.add(ListView(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                children: <Widget>[
                  SizedBox(height: 200.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          _hasLikes
                              ? "Don't Run Out of Likes!"
                              : "You're Out of Likes!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway')),
                      SizedBox(height: 24.0),
                      Text(
                          'A Lloud monthly subscription provides you with 20 likes per month. Likes can earn you points. Points can be redeemed for exclusive merch from the Lloud store.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, height: 1.5)),
                      SizedBox(height: 40.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                                onPressed: () async {
                                  PurchaserInfo purchaserInfo =
                                      await Purchases.identify("${user.id}");
                                  await buySubscription(context, monthly);
                                },
                                color: LloudTheme.red,
                                textColor: LloudTheme.white,
                                child: Text(
                                  'Subscribe Now - ${monthly.product.priceString}/mo',
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
                                  Navigator.pop(context);
                                },
                                textColor: LloudTheme.red,
                                child: Text(
                                  'Maybe Later',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ))
                        ],
                      ),
                    ],
                  )
                ],
              ));
            }
          }
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: stack,
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red)),
        ),
      ],
    );
  }
}
