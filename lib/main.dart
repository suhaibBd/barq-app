import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/locale/locale_notifier.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  await sl<NotificationService>().init();
  runApp(BarqApp(localeNotifier: sl<LocaleNotifier>()));
}

class BarqApp extends StatefulWidget {
  final LocaleNotifier localeNotifier;

  const BarqApp({super.key, required this.localeNotifier});

  @override
  State<BarqApp> createState() => _BarqAppState();
}

class _BarqAppState extends State<BarqApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(CheckAuthStatusEvent());
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<HomeBloc>(
          create: (_) => sl<HomeBloc>()..add(LoadHomeEvent()),
        ),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: widget.localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp.router(
            title: 'Barq',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: locale,
            supportedLocales: S.supportedLocales,
            localizationsDelegates: S.localizationsDelegates,
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
