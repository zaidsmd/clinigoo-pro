import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_user.dart';
import '../models/login_request.dart';
import '../models/professional_register_request.dart';
import '../repositories/auth_repository.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);
  final AuthUser user;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthInitial()) {
    checkAuthStatus();
  }

  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repository.me();
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = const Unauthenticated();
      }
    } catch (_) {
      state = const Unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.login(
        LoginRequest(email: email, password: password),
      );
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
      rethrow;
    }
  }

  Future<void> register(ProfessionalRegisterRequest request) async {
    state = const AuthLoading();
    try {
      final user = await _repository.register(request);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const Unauthenticated();
  }
}
