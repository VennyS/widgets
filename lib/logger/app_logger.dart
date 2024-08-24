import 'package:logger/logger.dart';

class AppLogger {
  // Единственный экземпляр логгера
  static final AppLogger _instance = AppLogger._internal();

  // Экземпляр Logger из пакета `logger`
  late final Logger _logger;

  // Приватный конструктор
  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Количество строк для отображения трассировки стека
        errorMethodCount:
            8, // Количество строк для отображения трассировки стека при ошибках
        lineLength: 120, // Максимальная длина строки
        colors: true, // Включить цветной вывод
        printEmojis: true, // Включить эмодзи
      ),
    );
  }

  // Фабричный конструктор для получения единственного экземпляра
  factory AppLogger() {
    return _instance;
  }

  // Обёртки для методов Logger
  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message) => _logger.e(message);
  void t(String message) => _logger.t(message);
}
