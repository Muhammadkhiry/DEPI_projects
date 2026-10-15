import 'package:flutter/material.dart';

class FindDoctorsView extends StatelessWidget {
  const FindDoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F9),
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Doctors',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF005B5C),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}