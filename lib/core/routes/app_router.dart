import 'package:go_router/go_router.dart';
import 'package:hells360/feature/authentication/view/login_register_screen.dart';
import 'package:hells360/feature/authentication/view/otp_screen.dart';
import 'package:hells360/feature/home_screen/view/home_screen.dart';
import 'package:hells360/feature/home_screen/view/profile_screen.dart';
import 'package:hells360/feature/splash/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'splash',
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginRegisterScreen(),
      ),
      GoRoute(
        name: 'otp',
        path: '/otp',
        builder: (context, state) {
          final mobileNumber = state.extra as String? ?? '';
          return OtpScreen(mobileNumber: mobileNumber);
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
         name: "profile",
        path: "/profile",
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
