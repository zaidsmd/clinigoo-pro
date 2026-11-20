sealed class AppException implements Exception {
  const AppException(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Erreur réseau, veuillez vérifier votre connexion']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Email ou mot de passe incorrect'])
      : super(message, 401);
}

class ValidationException extends AppException {
  const ValidationException(String message, {this.errors})
      : super(message, 422);

  final Map<String, dynamic>? errors;
}

class ServerException extends AppException {
  const ServerException([String message = 'Une erreur est survenue sur le serveur'])
      : super(message, 500);
}
