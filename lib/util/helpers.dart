import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:lloud_mobile/services/error_reporting.dart';

class Helpers {
  static String formatNumber(int stat) {
    String statStr = stat.toString();

    if (statStr.length <= 3) {
      return statStr;
    }

    if (statStr.length > 6) {
      return '${statStr.substring(0, (statStr.length - 6))}M';
    }

    return '${statStr.substring(0, (statStr.length - 3))}K';
  }

  static Future<Uint8List> getBytesFromNetworkImg(String url) async {
    try {
      final res = await http.get(url);
      return res.bodyBytes;
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    return null;
  }
}
