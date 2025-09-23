import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/club_provider.dart';
import 'providers/event_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/admin_provider.dart';

import 'router.dart';
import 'firebase_options.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ClubProvider>(
          create: (_) => ClubProvider(),
        ),
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(),
        ),
        ChangeNotifierProvider<AnnouncementProvider>(
          create: (_) => AnnouncementProvider(),
        ),
        ChangeNotifierProxyProvider2<EventProvider, AnnouncementProvider, AdminProvider>(
          create: (context) => AdminProvider(),
          update: (context, eventProvider, announcementProvider, previous) =>
          AdminProvider()..updateProviders(eventProvider, announcementProvider),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Club Management',

      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,

      initialRoute: Routes.login,
      onGenerateRoute: (settings) => generateRoute(settings, context),
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
