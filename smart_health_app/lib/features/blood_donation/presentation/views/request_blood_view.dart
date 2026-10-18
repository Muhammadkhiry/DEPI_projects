import 'package:flutter/material.dart';

class BloodDonationView extends StatelessWidget {
  const BloodDonationView({super.key});

  static const Color teal = Color(0xFF2D6867);
  static const Color bloodRed = Color(0xFFB1323B);
  static const Color pageBackground = Color(0xFFF1FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: const Color(0xFF292929),
        foregroundColor: Colors.white,
        title: const Text('Blood Donation'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: teal,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.volunteer_activism, color: Colors.white, size: 42),
                SizedBox(height: 12),
                Text(
                  'Donate Blood, Save Lives',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your donation can make a difference.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Blood Donation Services',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17272B),
            ),
          ),
          const SizedBox(height: 14),
          _serviceCard(
            icon: Icons.bloodtype,
            title: 'Blood Requests',
            subtitle: 'Find patients who need blood',
            color: bloodRed,
            onTap: () => _openPage(
              context,
              'Blood Requests',
              'View blood requests and help patients in need.',
            ),
          ),
          _serviceCard(
            icon: Icons.person_search,
            title: 'Find Donors',
            subtitle: 'Search for available blood donors',
            color: teal,
            onTap: () => _openPage(
              context,
              'Find Donors',
              'Search for donors by blood type and location.',
            ),
          ),
          _serviceCard(
            icon: Icons.add_circle_outline,
            title: 'Request Blood',
            subtitle: 'Create a new blood request',
            color: bloodRed,
            onTap: () => _openPage(
              context,
              'Request Blood',
              'Create a request for the blood you need.',
            ),
          ),
          _serviceCard(
            icon: Icons.history,
            title: 'Donation History',
            subtitle: 'Review your previous donations',
            color: teal,
            onTap: () => _openPage(
              context,
              'Donation History',
              'Your previous donation records will appear here.',
            ),
          ),
          _serviceCard(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Stay updated on your requests',
            color: teal,
            onTap: () => _openPage(
              context,
              'Notifications',
              'Your latest notifications will appear here.',
            ),
          ),
          _serviceCard(
            icon: Icons.emergency_outlined,
            title: 'Emergency Numbers',
            subtitle: 'Find important emergency contacts',
            color: bloodRed,
            onTap: () => _openPage(
              context,
              'Emergency Numbers',
              'Emergency contact information will appear here.',
            ),
          ),
        ],
      ),
    );
  }

  static Widget _serviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD5E0E0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.10),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  static void _openPage(BuildContext context, String title, String message) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: pageBackground,
          appBar: AppBar(
            backgroundColor: const Color(0xFF292929),
            foregroundColor: Colors.white,
            title: Text(title),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, color: Color(0xFF2D6867)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
