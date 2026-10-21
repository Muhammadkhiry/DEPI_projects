import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user_cubit/user_cubit.dart';
import '../cubit/user_cubit/user_states.dart';
import '../views/log_in_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffF8F9FA),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<UserCubit, UserStates>(
            builder: (context, state) {
              final userName = context.watch<UserCubit>().userName;
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xff00A896), // الهيدر باللون الأساسي
                ),
                accountName: Text(
                  userName.isEmpty ? "User" : userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: const Text(
                  "Local Storage Account",
                  style: TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xff00A896)),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: Color(0xff00A896)),
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.pop(context);
              _showEditProfileDialog(context);
            },
          ),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () async {
              Navigator.pop(context);
              await context.read<UserCubit>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInView()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext parentContext) {
    final userCubit = parentContext.read<UserCubit>();
    final nameController = TextEditingController(text: userCubit.userName);

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Update Profile"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "New Name",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xff00A896)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00A896),
              ),
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await userCubit.saveUserProfile(newName);
                }
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}