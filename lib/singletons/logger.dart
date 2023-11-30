import 'package:logger/logger.dart';

class LoggerSingleton {
  static final LoggerSingleton _singleton = LoggerSingleton._internal();
  late Logger logger;

  factory LoggerSingleton() {
    return _singleton;
  }

  LoggerSingleton._internal() {
    logger = Logger(
      level: Level.debug, // Set your desired log level
    );
  }
}
