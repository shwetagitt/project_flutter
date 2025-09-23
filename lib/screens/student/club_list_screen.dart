import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/auth_provider.dart';
import '../../router.dart';
import '../../widgets/club_card.dart';

class ClubListScreen extends StatelessWidget {
  const ClubListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clubProvider = Provider.of<ClubProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('🏛️ Browse Clubs'),
        backgroundColor: Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: clubProvider.clubs.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: clubProvider.clubs.length,
        itemBuilder: (context, index) {
          final club = clubProvider.clubs[index];

          return ClubCard(
            clubName: club.name,
            description: club.description,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.clubDetails,
                arguments: club.id,
              );
            },
            trailing: currentUser != null && !currentUser.isAdmin
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Join', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              onPressed: () async {
                try {
                  await clubProvider.requestToJoin(
                    club.id,
                    currentUser.id,
                    currentUser.email,
                    club.name,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text('Join request sent for ${club.name}!')),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text(e.toString().replaceFirst('Exception: ', ''))),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  }
                }
              },
            )
                : null,
          );
        },
      ),
    );
  }
}
