abstract final class ApiConstants {
  /// Base API URL. Configured via `.env` (`API_BASE_URL`) or `--dart-define=API_BASE_URL=...`
  static const String defaultBaseUrl = 'http://127.0.0.1:8000';

  /// Base Web URL. Configured via `.env` (`WEB_BASE_URL`) or `--dart-define=WEB_BASE_URL=...`
  static const String defaultWebBaseUrl = 'http://127.0.0.1:300';

  /// Web login page path where professionals authenticate to upload documents.
  static const String webLoginPath = '/login';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';
  static const String refresh = '/api/auth/refresh';

  // Professions & Services
  static const String professions = '/api/professions';
  static const String services = '/api/services';
  static const String professionalDossier = '/api/professional/dossier';
}
