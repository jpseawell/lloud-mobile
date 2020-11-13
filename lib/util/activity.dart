import 'package:lloud_mobile/util/dal.dart';

class Activity {
  static Future<void> reportPageView(String route) async {
    final res = await DAL
        .instance()
        .post('activities', {'type': 'view', 'page': route});
  }
}