import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('🎓 Student Portal'),
        backgroundColor: Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, Routes.profile),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStudentWelcomeCard(context, user),
              SizedBox(height: 24),
              _buildStudentQuickActions(context),
              SizedBox(height: 24),
              _buildYourClubs(context),
              SizedBox(height: 24),
              _buildUpcomingEvents(context, eventProvider),
              SizedBox(height: 24),
              _buildRecentAnnouncements(context, announcementProvider),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentWelcomeCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E40AF).withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: Text(
                user?.name?.isNotEmpty == true ? user!.name[0].toUpperCase() : 'S',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('👋 Welcome back,', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                SizedBox(height: 4),
                Text(user?.name ?? 'Student',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Student Portal',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('⚡ Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildActionCard('Browse Clubs', '🏛️', Color(0xFF1E40AF), () => Navigator.pushNamed(context, Routes.clubList)),
            _buildActionCard('Events', '🎉', Color(0xFF059669), () => Navigator.pushNamed(context, Routes.events)),
            _buildActionCard('Announcements', '📢', Color(0xFF7C3AED), () => Navigator.pushNamed(context, Routes.announcements)),
            _buildActionCard('My Profile', '👤', Color(0xFFD97706), () => Navigator.pushNamed(context, Routes.profile)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String emoji, Color color, VoidCallback onTap) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: 32)),
              SizedBox(height: 12),
              Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYourClubs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('🏛️ Your Clubs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, Routes.clubList),
              icon: Icon(Icons.explore, size: 16),
              label: Text('Browse All'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF1E40AF)),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 120, // Fixed height to prevent overflow
          child: Card(
            elevation: 8,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.clubList),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Color(0xFFEBF4FF), Color(0xFFDBEAFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, size: 40, color: Color(0xFF1E40AF)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🚀 Join your first club!',
                              style: TextStyle(color: Color(0xFF1E40AF), fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Discover amazing communities',
                              style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, EventProvider eventProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('🎉 Upcoming Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, Routes.events),
              icon: Icon(Icons.calendar_today, size: 16),
              label: Text('View All'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF059669)),
            ),
          ],
        ),
        SizedBox(height: 16),
        eventProvider.events.isEmpty
            ? SizedBox(
          height: 120, // Fixed height
          child: Card(
            elevation: 8,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFEF3C7).withOpacity(0.7)]),
              ),
              child: Row(
                children: [
                  Text('📅', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No upcoming events',
                            style: TextStyle(color: Color(0xFFD97706), fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Check back later for exciting events!',
                            style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : Column(
          children: eventProvider.events.take(2).map((event) => Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 6,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [Color(0xFFECFDF5), Colors.white]),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF059669),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.event, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3748))),
                          SizedBox(height: 4),
                          Text(event.clubName,
                              style: TextStyle(fontSize: 12, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('${event.date.day}/${event.date.month}/${event.date.year}',
                              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentAnnouncements(BuildContext context, AnnouncementProvider announcementProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('📢 Recent Announcements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, Routes.announcements),
              icon: Icon(Icons.notifications, size: 16),
              label: Text('View All'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF7C3AED)),
            ),
          ],
        ),
        SizedBox(height: 16),
        announcementProvider.announcements.isEmpty
            ? SizedBox(
          height: 120, // Fixed height
          child: Card(
            elevation: 8,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [Color(0xFFF3E8FF), Color(0xFFF3E8FF).withOpacity(0.7)]),
              ),
              child: Row(
                children: [
                  Text('🔔', style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No recent announcements',
                            style: TextStyle(color: Color(0xFF7C3AED), fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Stay tuned for updates!',
                            style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : Column(
          children: announcementProvider.announcements.take(2).map((announcement) => Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 6,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [Color(0xFFF3E8FF), Colors.white]),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.announcement, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(announcement.title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3748))),
                          SizedBox(height: 4),
                          Text(announcement.body,
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.3),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
