import 'package:flutter/material.dart';

class NoTasksWidget extends StatelessWidget {
  const NoTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Image.asset("assets/undraw_no.png", fit: BoxFit.fill)),
        Expanded(
          child: Text(
            "You have no tasks yet!",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 25),
        Expanded(
          child: Text(
            "Tap + to add your first task",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
