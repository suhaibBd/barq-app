import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/driver_setup_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_entry_page.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/ratings/presentation/pages/rate_user_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/shipments/presentation/pages/shipments_page.dart';
import '../../features/shipments/presentation/pages/create_shipment_page.dart';
import '../../shared/widgets/main_shell.dart';

class AuthChangeNotifier extends ChangeNotifier {
  late final StreamSubscription _sub;

  AuthChangeNotifier(AuthBloc authBloc) {
    _sub = authBloc.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthBloc authBloc;
  late final AuthChangeNotifier _authNotifier;

  AppRouter(this.authBloc) {
    _authNotifier = AuthChangeNotifier(authBloc);
  }

  void dispose() => _authNotifier.dispose();

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      final authState = authBloc.state;

      if (authState is AuthLoading || authState is AuthInitial) {
        return null;
      }

      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/phone';
      }
      if (isAuthenticated && isAuthRoute) {
        final isOnOtp = state.matchedLocation == '/auth/otp';
        final isOnRoleSelection =
            state.matchedLocation == '/auth/role-selection';
        final isOnSetup = state.matchedLocation == '/auth/driver-setup' ||
            state.matchedLocation == '/auth/passenger-setup';

        if (authState.isNewUser && (isOnOtp || isOnRoleSelection || isOnSetup)) {
          return null;
        }
        if (authState.isNewUser) {
          return '/auth/role-selection';
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
            devCode: extra['devCode'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/auth/role-selection',
        builder: (_, __) => const RoleSelectionPage(),
      ),
      GoRoute(
        path: '/auth/passenger-setup',
        builder: (_, __) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: '/auth/driver-setup',
        builder: (_, __) => const DriverSetupPage(),
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
              path: '/orders',
              builder: (_, __) => const ShipmentsPage(),
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

      // Order create (outside shell)
      GoRoute(
        path: '/orders/create',
        builder: (_, __) => const CreateShipmentPage(),
      ),

      // Detail routes
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile/driver-verification',
        builder: (_, __) => const DriverSetupPage(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (_, __) => const WalletPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/rate',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RateUserPage(
            bookingId: extra['bookingId'] as String,
            ratedUserId: extra['ratedUserId'] as String,
            ratedUserName: extra['ratedUserName'] as String,
            isDriver: extra['isDriver'] as bool? ?? false,
          );
        },
      ),
    ],
  );
}
