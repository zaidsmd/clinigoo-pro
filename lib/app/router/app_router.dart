import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/dashboard/presentation/professional_dashboard_screen.dart';
import '../../features/registration/presentation/professional_registration_screen.dart';
import '../../features/registration/presentation/registration_success_screen.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const ProfessionalRegistrationScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerSuccess,
        builder: (context, state) => const RegistrationSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const ProfessionalDashboardScreen(),
      ),
    ],
  );
});
