import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Base URL configurada para resolver automaticamente o ambiente de execução:
  /// - Web / Desktop / Simulador iOS: http://localhost:3000
  /// - Emulador Android: http://10.0.2.2:3000
  /// - Celular físico via USB: http://localhost:3000 (com adb reverse tcp:3000 tcp:3000)
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }
}
