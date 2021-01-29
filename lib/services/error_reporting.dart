import 'package:sentry/sentry.dart';

class ErrorReportingService {
  static Future<void> report(dynamic throwable, {dynamic stackTrace}) async {
    await Sentry.captureException(
      throwable,
      stackTrace: stackTrace,
    );
  }
}
