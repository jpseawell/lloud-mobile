import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lloud_mobile/util/dal.dart';

/// PurchaseHandler tracks and responds to in-app purchases in the Lloud application.
/// I intentionally made this a static class for the purpose of managing a
/// single InAppPurchaseConnection.

class PurchaseHandler {
  static InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  static bool _available = true;
  static List<ProductDetails> _products = [];
  static List<PurchaseDetails> _purchases = [];
  static StreamSubscription _subscription;

  static Future<void> listen(Function cb) async {
    _available = await _iap.isAvailable();
    if (!_available) {
      throw Exception('No store connection is available.');
    }

    await _getProducts();
    await _getPastPurchases();

    // _verifyPurchase();

    _subscription = _iap.purchaseUpdatedStream.listen(
        (List<PurchaseDetails> purchaseDetails) =>
            purchaseDetails.forEach((purchase) => cb(purchase)));
  }

  static void stopListening() {
    _subscription.cancel();
  }

  static Future<void> _getProducts() async {
    Set<String> ids = <String>['like_refill.20mo'].toSet();
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
  }

  static Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.completePurchase(purchase);
      }
    }

    _purchases = response.pastPurchases;
  }

  static bool hasPurchased(String productId) {
    PurchaseDetails pastPurchase = _purchases.firstWhere(
        (purchase) => purchase.productID == productId,
        orElse: () => null);
    return !(pastPurchase == null);
  }

  static Future<bool> verify(PurchaseDetails purchaseDetails) async {
    Map<String, String> receiptData = {
      'platform': Platform.operatingSystem,
      'product_id': purchaseDetails.productID,
      'verification_data':
          purchaseDetails.verificationData.serverVerificationData
    };
    dynamic dal = DAL.instance();
    Response response = await dal.post('purchase-updates/verify', receiptData);
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    return decodedResponse['verified'];
  }

  static void buySubscription() {
    ProductDetails pd = _products.firstWhere(
        (product) => product.id == 'like_refill.20mo',
        orElse: () => null);
    _buyProduct(pd);
  }

  static void complete(PurchaseDetails purchase) {
    _iap.completePurchase(purchase);
  }

  static void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  static Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'like_refill.20mo') {
      final Response response =
          await DAL.instance().post('subscriptions/upgrade', {});
      if (response.statusCode == 200) {
        return;
      }

      throw Exception("Failed to deliver product.");
    }
  }
}
