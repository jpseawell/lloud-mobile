import 'package:flutter/cupertino.dart';

class Purchases with ChangeNotifier {
  static const String listening = 'listening';
  static const String pending = 'pending';
  static const String complete = 'complete';
  static const String failed = 'failed';

  String _status = listening;
  List<String> statuses = [listening, pending, complete, failed];

  String get status => _status;

  setStatus(String status) {
    if (!statuses.contains(status)) {
      // TODO: Throw an error
    }

    _status = status;
    notifyListeners();
  }
}
