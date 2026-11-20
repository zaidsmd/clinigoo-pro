import 'package:dio/dio.dart';

import '../../../app/config/api_constants.dart';
import '../../api/api_client.dart';
import '../../errors/app_exception.dart';
import '../models/auth_user.dart';
import '../models/login_request.dart';
import '../models/professional_register_request.dart';
import '../storage/token_storage.dart';
import 'auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required ApiClient apiClient,
    required this.tokenStorage,
  }) : _dio = apiClient.dio;

  final Dio _dio;
  final TokenStorage tokenStorage;

  @override
  Future<AuthUser> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['access_token']?.toString() ??
          data['token']?.toString() ??
          '';

      if (token.isNotEmpty) {
        await tokenStorage.saveTokens(accessToken: token);
      }

      final user = await me();
      if (user != null) return user;

      return AuthUser(
        id: '',
        email: request.email,
        firstName: '',
        lastName: '',
        role: 'professional',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthUser> register(ProfessionalRegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['access_token']?.toString() ??
          data['token']?.toString() ??
          '';

      if (token.isNotEmpty) {
        await tokenStorage.saveTokens(accessToken: token);
      }

      // Fetch freshly registered user
      try {
        final user = await me();
        if (user != null) return user;
      } catch (_) {
        // Fallback to local request info
      }

      return AuthUser(
        id: '',
        email: request.email,
        firstName: request.firstName,
        lastName: request.lastName,
        role: 'professional',
        gender: request.gender,
        cinNumber: request.cinNumber,
        city: request.city,
        phone: request.phone,
        birthDate: request.birthDate,
        status: 'draft',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthUser?> me() async {
    try {
      final token = await tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(ApiConstants.me);
      if (response.data is Map<String, dynamic>) {
        return AuthUser.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await tokenStorage.clear();
        return null;
      }
      throw _handleDioError(e);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      await tokenStorage.clear();
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    if (statusCode == 401) {
      return const UnauthorizedException('Identifiants incorrects.');
    }

    if (statusCode == 422 && responseData is Map<String, dynamic>) {
      final message = responseData['message']?.toString() ??
          'Certaines informations sont invalides.';
      final errors = responseData['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final firstErrorList = errors.values.first;
        if (firstErrorList is List && firstErrorList.isNotEmpty) {
          return ValidationException(firstErrorList.first.toString(), errors: errors);
        }
      }
      return ValidationException(message, errors: errors);
    }

    if (statusCode != null && statusCode >= 500) {
      return const ServerException('Erreur serveur interne.');
    }

    return ServerException(
      responseData is Map ? responseData['message']?.toString() ?? 'Une erreur est survenue' : 'Une erreur est survenue',
    );
  }
}
