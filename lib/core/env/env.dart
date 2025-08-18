import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration helper.
class Env {
  Env._();

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // ignore missing env file
    }
  }

  /// Returns the BASE_URL configuration.
  static String get baseUrl {
    const fromDefine = String.fromEnvironment('BASE_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    return dotenv.env['BASE_URL'] ?? '';
  }
}
