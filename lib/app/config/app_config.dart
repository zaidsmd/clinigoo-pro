import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_constants.dart';

class AppConfig {
  static const String appName = 'Clinigoo Pro';

  static String get baseUrl {
    const defined = String.fromEnvironment('API_BASE_URL');
    if (defined.isNotEmpty) return defined;
    final fromEnv = dotenv.isInitialized ? dotenv.maybeGet('API_BASE_URL') : null;
    if (fromEnv != null && fromEnv.trim().isNotEmpty) return fromEnv.trim();
    return ApiConstants.defaultBaseUrl;
  }

  static String get webBaseUrl {
    const defined = String.fromEnvironment('WEB_BASE_URL');
    if (defined.isNotEmpty) return defined;
    final fromEnv = dotenv.isInitialized ? dotenv.maybeGet('WEB_BASE_URL') : null;
    if (fromEnv != null && fromEnv.trim().isNotEmpty) return fromEnv.trim();
    return ApiConstants.defaultWebBaseUrl;
  }

  static Uri get webLoginUri {
    final trimmed = webBaseUrl.replaceAll(RegExp(r'/+$'), '');
    return Uri.parse('$trimmed${ApiConstants.webLoginPath}');
  }
}
