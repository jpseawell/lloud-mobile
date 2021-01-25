import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Products with ChangeNotifier {
  final String _productKey = 'lloud.likes_refill.10_for_5';
  Product _product;

  Product get product => _product;

  Future<void> fetchAndSetProduct() async {
    List<Product> products = await Purchases.getProducts([_productKey]);

    _product = products.first;
    notifyListeners();
  }
}
