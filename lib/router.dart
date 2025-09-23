import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

// Common screens
import 'screens/common/login_screen.dart';
import 'screens/common/register_screen.dart';
import 'screens/common/dashboard_screen.dart';

// Student screens
import 'screens/student/club_list_screen.dart';
import 'screens/student/club_details_screen.dart';
import 'screens/student/events_screen.dart';
import 'screens/student/announcements_screen.dart';
import 'screens/student/members_list_screen.dart';
import 'screens/student/profile_screen.dart';
import 'screens/student/settings_screen.dart';

// Admin screens
import 'screens/admin/admin_dashboard_screen.dart';  // ← ADD THIS
import 'screens/admin/admin_panel_screen.dart';
import 'screens/admin/join_requests_screen.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const adminDashboard = '/admin-dashboard';

  // Student routes
  static const clubList = '/club-list';
  static const clubDetails = '/club-details';
  static const events = '/events';
  static const announcements = '/announcements';
  static const membersList = '/members-list';
  static const profile = '/profile';
  static const settings = '/settings';

  // Admin routes
  static const adminPanel = '/admin-panel';
  static const joinRequests = '/join-requests';
}

Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final isAdmin = authProvider.currentUser?.isAdmin ?? false;
  final isAuthenticated = authProvider.isAuthenticated;

  print('🛣️ Navigating to: ${settings.name}');

  switch (settings.name) {
    case Routes.login:
      return MaterialPageRoute(builder: (_) => LoginScreen());

    case Routes.register:
      return MaterialPageRoute(builder: (_) => RegisterScreen());

    case Routes.dashboard:
      print('📱 Loading Student Dashboard');
      return MaterialPageRoute(builder: (_) => DashboardScreen());

    case Routes.adminDashboard:
      print('🛡️ Loading Admin Dashboard');
      return MaterialPageRoute(builder: (_) => AdminDashboardScreen());

    case Routes.clubList:
      return MaterialPageRoute(builder: (_) => ClubListScreen());

    case Routes.clubDetails:
      final clubId = settings.arguments as String? ?? '1';
      return MaterialPageRoute(builder: (_) => ClubDetailsScreen(clubId: clubId));

    case Routes.events:
      return MaterialPageRoute(builder: (_) => EventsScreen());

    case Routes.announcements:
      return MaterialPageRoute(builder: (_) => AnnouncementsScreen());

    case Routes.membersList:
      final clubId = settings.arguments as String? ?? '1';
      return MaterialPageRoute(builder: (_) => MembersListScreen(clubId: clubId));

    case Routes.profile:
      return MaterialPageRoute(builder: (_) => ProfileScreen());

    case Routes.settings:
      return MaterialPageRoute(builder: (_) => SettingsScreen());

    case Routes.adminPanel:
      if (!isAdmin) return _accessDeniedRoute();
      return MaterialPageRoute(builder: (_) => AdminPanelScreen());

    case Routes.joinRequests:
      if (!isAdmin) return _accessDeniedRoute();
      return MaterialPageRoute(builder: (_) => JoinRequestsScreen());

    default:
      return MaterialPageRoute(builder: (_) => LoginScreen());
  }
}

Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text('Error: $message')),
    ),
  );
}

Route<dynamic> _accessDeniedRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: Text('Access Denied')),
      body: Center(child: Text('Access Denied')),
    ),
  );
}
