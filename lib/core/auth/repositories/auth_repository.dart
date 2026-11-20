import '../models/auth_user.dart';
import '../models/login_request.dart';
import '../models/professional_register_request.dart';

abstract class AuthRepository {
  Future<AuthUser> login(LoginRequest request);
  Future<AuthUser> register(ProfessionalRegisterRequest request);
  Future<AuthUser?> me();
  Future<void> logout();
}
