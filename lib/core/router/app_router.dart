import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_entry_page.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/bookings/presentation/pages/create_booking_page.dart';
import '../../features/bookings/presentation/pages/my_bookings_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/trips/presentation/pages/search_page.dart';
import '../../features/trips/presentation/pages/trip_details_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../shared/widgets/main_shell.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/phone';
      }
      if (isAuthenticated && isAuthRoute) {
        if (authState.isNewUser) {
          return '/auth/profile-setup';
        }
        return '/home';
      }
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/auth/phone',
        builder: (_, __) => const PhoneEntryPage(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpPage(
            verificationId: extra['verificationId'] as String,
            phone: extra['phone'] as String,
          );
        },
      ),
      GoRoute(
        path: '/auth/profile-setup',
        builder: (_, __) => const ProfileSetupPage(),
      ),

      // Main app with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/search',
              builder: (_, __) => const SearchPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/my-trips',
              builder: (_, __) => const MyBookingsPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfilePage(),
            ),
          ]),
        ],
      ),

      // Detail routes (outside shell)
      GoRoute(
        path: '/trips/:id',
        builder: (_, state) =>
            TripDetailsPage(tripId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/bookings/create/:tripId',
        builder: (_, state) =>
            CreateBookingPage(tripId: state.pathParameters['tripId']!),
      ),
      GoRoute(
        path: '/wallet',
        builder: (_, __) => const WalletPage(),
      ),
    ],
  );
}
