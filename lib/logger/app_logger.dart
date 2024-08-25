import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;

  late final Logger _logger;

  factory AppLogger() {
    return _instance;
  }

  static void d(String message) => instance._logger.d(message);
  static void i(String message) => instance._logger.i(message);
  static void w(String message) => instance._logger.w(message);
  static void e(String message) => instance._logger.e(message);
  static void t(String message) => instance._logger.t(message);
}
