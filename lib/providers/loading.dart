import 'package:flutter/material.dart';

class Loading with ChangeNotifier {
  bool _isLoading = false;

  bool get loading => _isLoading;

  set loading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
