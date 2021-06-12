import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:lloud_mobile/providers/products.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/providers/loading.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class InlineBuyBtn extends StatefulWidget {
  InlineBuyBtn();

  @override
  _InlineBuyBtnState createState() => _InlineBuyBtnState();
}

class _InlineBuyBtnState extends State<InlineBuyBtn> {
  final String _productKey = 'lloud.likes_refill.10_for_5';

  _InlineBuyBtnState();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _purchaseLikes(BuildContext context) async {
    final mixpanel = Provider.of<Mixpanel>(context, listen: false);
    mixpanel.track('Clicked Like Refill Button');
    final loadingProvider = Provider.of<Loading>(context, listen: false);
    loadingProvider.loading = true;
    try {
      final authProvider = Provider.of<Auth>(context, listen: false);
      await Purchases.identify('${authProvider.userId}');
      await Purchases.purchaseProduct(_productKey);

      final account = authProvider.account;
      account.likesBalance += 10;
      await authProvider.updateAccount(account);

      _likesPurchasedDialog(context);
      mixpanel.track('Purchased 10 Likes');
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        print("User cancelled");
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        print("User not allowed to purchase");
      }
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }
    loadingProvider.loading = false;
  }

  void _likesPurchasedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: LloudTheme.red,
            title: Stack(alignment: Alignment.center, children: [
              Icon(
                Icons.favorite,
                size: 80,
                color: LloudTheme.white.withOpacity(.25),
              ),
              Text(
                '+10 Likes',
                style: TextStyle(
                    shadows: [
                      Shadow(
                          color: LloudTheme.black.withOpacity(.25),
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ],
                    color: LloudTheme.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900),
              )
            ]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              "We added 10 likes to your likes balance!\nThanks for playing!",
              textAlign: TextAlign.center,
            ),
            contentTextStyle: TextStyle(color: LloudTheme.white),
          );
        });

    Timer(new Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    return Card(
      elevation: 4,
      borderOnForeground: true,
      color: LloudTheme.red,
      child: Container(
        padding: EdgeInsets.all(8),
        height: 68,
        child: InkWell(
          splashColor: LloudTheme.white.withAlpha(30),
          onTap: () async {
            HapticFeedback.heavyImpact();
            await _purchaseLikes(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '+10 Likes',
                style: TextStyle(
                    shadows: [
                      Shadow(
                          color: LloudTheme.black.withOpacity(.25),
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ],
                    color: LloudTheme.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900),
              ),
              if (productsProvider.product != null)
                Text(
                  'for \$${productsProvider.product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: LloudTheme.white, fontSize: 16),
                )
            ],
          ),
        ),
      ),
    );
  }
}
