import 'package:flutter/material.dart';

class BloodNotificationsView extends StatelessWidget {
  const BloodNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Request update',
        'Your blood request status may be updated here.',
        Icons.bloodtype,
      ),
      (
        'Donation reminder',
        'Check your donation schedule.',
        Icons.notifications_active_outlined,
      ),
      (
        'Welcome',
        'Thank you for being part of the blood donation community.',
        Icons.favorite_outline,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF2D6867),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.notifications_outlined),
              ),
              title: Text(item.$1),
              subtitle: Text(item.$2),
              trailing: Icon(item.$3, color: const Color(0xFF2D6867)),
            ),
          );
        },
      ),
    );
  }
}
