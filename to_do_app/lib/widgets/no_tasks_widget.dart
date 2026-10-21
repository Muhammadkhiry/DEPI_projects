import 'package:flutter/material.dart';

class NoTasksWidget extends StatelessWidget {
  const NoTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_tasks.png', // أو الأيقونة الخاصة بك
            width: 140,
            height: 140,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "You have no tasks yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap + to add your first task",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}