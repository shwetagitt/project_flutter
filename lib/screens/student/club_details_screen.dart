import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/event_provider.dart';
import '../../router.dart';

class ClubDetailsScreen extends StatefulWidget {
  final String clubId;

  const ClubDetailsScreen({Key? key, required this.clubId}) : super(key: key);

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch members when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClubProvider>(context, listen: false)
          .fetchMembersForClub(widget.clubId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubProvider = Provider.of<ClubProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final club = clubProvider.getClubById(widget.clubId);

    if (club == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Club Details')),
        body: Center(child: Text('Club not found')),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(club.name),
        backgroundColor: Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Header Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      club.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '👥 ${club.membersCount} members',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Upcoming Events Section
            _buildUpcomingEvents(context, widget.clubId, eventProvider),

            SizedBox(height: 24),

            // Members Section
            _buildMembersSection(context, clubProvider),

            SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, String clubId, EventProvider eventProvider) {
    // Filter events for this club
    final clubEvents = eventProvider.events.where((event) => event.clubId == clubId).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🎉 Upcoming Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, Routes.events),
              icon: Icon(Icons.calendar_today, size: 16),
              label: Text('View All'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF1E40AF)),
            ),
          ],
        ),
        SizedBox(height: 16),
        clubEvents.isEmpty
            ? Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_today, color: Colors.orange, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No upcoming events',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Check back later for exciting events!',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
            : Column(
          children: clubEvents.take(3).map((event) => Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1E40AF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.event, color: Colors.white, size: 20),
              ),
              title: Text(event.title, style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${event.date.day}/${event.date.month}/${event.date.year}'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1E40AF)),
              onTap: () => Navigator.pushNamed(context, Routes.events),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildMembersSection(BuildContext context, ClubProvider clubProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '👥 Members',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, Routes.membersList, arguments: widget.clubId),
              icon: Icon(Icons.group, size: 16),
              label: Text('View All'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF1E40AF)),
            ),
          ],
        ),
        SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: clubProvider.members.take(3).map((member) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF1E40AF),
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(member.name, style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(member.role),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, Routes.events),
            icon: Icon(Icons.event),
            label: Text('View Events'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, Routes.membersList, arguments: widget.clubId),
            icon: Icon(Icons.group),
            label: Text('View Members'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF1E40AF),
              side: BorderSide(color: Color(0xFF1E40AF)),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
